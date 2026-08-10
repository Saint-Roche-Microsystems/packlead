import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/srmc_hq.dart';
import 'package:packlead/core/errors/error_handler.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/widgets/error_screen.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_location_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_route_provider.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/order_bottom_sheet.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/route_tracking_map.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/status_tracking_badge.dart';
import 'package:packlead/services/location/location_tracking_service.dart';

class DispatcherHomeScreen extends ConsumerStatefulWidget {
  // Firebase UID - used only for RTDB tracking (locations/{firebaseUid}).
  // Order-related backend calls need the domain dispatcher id instead,
  // resolved below via GET /dispatchers/me.
  final String dispatcherId;
  final String dispatcherEmail;

  const DispatcherHomeScreen({
    super.key,
    required this.dispatcherId,
    required this.dispatcherEmail
  });

  @override
  ConsumerState<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends ConsumerState<DispatcherHomeScreen> {
  bool _hasLoadedOrders = false;
  bool _hasInitializedTracking = false;
  bool _isLoggingOut = false;
  LocationTrackingService? _trackingService;
  DispatcherLocationNotifier? _locationNotifier;

  // The RTDB node must be removed while the dispatcher is still authenticated
  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);

    if (_trackingService != null) {
      _trackingService!.stopTracking();
    }

    if (_locationNotifier != null) {
      await _locationNotifier!.unregister();
    }

    if (mounted) {
      await ref.read(authStateProvider.notifier).logout();
    }
  }

  // Start GPS tracking and register the dispatcher's location in RTDB
  // Only meant to run once, and only after today's orders have loaded
  Future<void> _initializeTracking() async {
    if (!mounted) return;

    _trackingService = ref.read(locationTrackingServiceProvider);
    _trackingService!.startTracking();

    ref.read(isTrackingActiveProvider.notifier).state = true;

    // Get initial location (could be null)
    final currentLocation = ref.read(dispatcherCurrentLocationProvider);

    // If current location is null, use SRMC HQ as default initial location
    final initialLocation = currentLocation ?? srmchq;

    _locationNotifier = ref.read(dispatcherLocationProvider.notifier);

    await _locationNotifier!.register(
      dispatcherId: widget.dispatcherId,
      email: widget.dispatcherEmail,
      initialLocation: initialLocation,
    );
  }

  @override
  void dispose() {
    if(_trackingService != null) {
      _trackingService!.stopTracking();
    }

    if(_locationNotifier != null) {
      _locationNotifier!.unregister();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meAsync = ref.watch(dispatcherMeProvider);

    // Load today's orders using the backend dispatcher id (GET /dispatchers/me)
    // - not the Firebase UID - exactly once, as soon as the profile resolves.
    ref.listen<AsyncValue<Dispatcher>>(dispatcherMeProvider, (previous, next) {
      final me = next.valueOrNull;
      if (me != null && !_hasLoadedOrders) {
        _hasLoadedOrders = true;
        ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(me.id);
      }
    });

    // Start tracking/RTDB registration exactly once, and only once today's
    // orders have actually loaded successfully.
    ref.listen<AsyncValue<dynamic>>(dispatcherHomeProvider, (previous, next) {
      if (!_hasInitializedTracking && next.hasValue) {
        _hasInitializedTracking = true;
        _initializeTracking();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Packlead'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Salir',
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _handleLogout,
          ),
        ],
      ),
      body: meAsync.when(
        data: (me) => _buildBody(context, me.id),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorScreen(
          title: 'Error al cargar tu perfil',
          message: ErrorHandler.getErrorMessage(error),
          onRetry: () => ref.invalidate(dispatcherMeProvider),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String domainDispatcherId) {
    final homeState = ref.watch(dispatcherHomeProvider);

    return homeState.when(
      data: (state) => _buildContent(context, state, domainDispatcherId),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorScreen(
        title: 'Error al cargar tus órdenes',
        message: ErrorHandler.getErrorMessage(error),
        onRetry: () => ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(domainDispatcherId),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic state, String domainDispatcherId) {
    final currentLocation = ref.watch(dispatcherCurrentLocationProvider);

    return Stack(
      children: [
        // MAP
        Positioned.fill(
          child: RouteTrackingMap(
            destination: state.selectedOrder?.location,
            selectedOrder: state.selectedOrder,
            currentPosition: currentLocation,
            hqLocation: srmchq,
          ),
        ),

        // TRACK STATE
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StatusTrackingBadge(),
          ),
        ),

        // BOTTOM SHEET
        OrderBottomSheet(dispatcherId: domainDispatcherId),
      ],
    );
  }
}
