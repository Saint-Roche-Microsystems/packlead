import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/srmc_hq.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_location_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_route_provider.dart';
import 'package:packlead/features/dispatcher/presentation/screens/home_screen_error.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/order_bottom_sheet.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/route_tracking_map.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/status_tracking_badge.dart';
import 'package:packlead/services/location/location_tracking_service.dart';

class DispatcherHomeScreen extends ConsumerStatefulWidget {
  final String dispatcherId;
  final String dispatcherName;

  const DispatcherHomeScreen({
    super.key,
    required this.dispatcherId,
    required this.dispatcherName
  });

  @override
  ConsumerState<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends ConsumerState<DispatcherHomeScreen> {
  bool _hasInitializedTracking = false;
  LocationTrackingService? _trackingService;
  DispatcherLocationNotifier? _locationNotifier;

  @override
  void initState() {
    super.initState();

    // fetch today's orders when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(widget.dispatcherId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initiate tracking only for once
    if (!_hasInitializedTracking) {
      _hasInitializedTracking = true;

      // Start traking with the provider service
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          _trackingService = ref.read(locationTrackingServiceProvider);
          _trackingService!.startTracking();

          ref.read(isTrackingActiveProvider.notifier).state = true;

          // Get initial location (could be null)
          final currentLocation = ref.read(dispatcherCurrentLocationProvider);

          // If current location is null, use SRMC HQ as default initial location
          final initialLocation = currentLocation ?? SRMCHQ;

          _locationNotifier = ref.read(dispatcherLocationProvider.notifier);

          await _locationNotifier!.register(
            dispatcherId: widget.dispatcherId,
            name: widget.dispatcherName,
            initialLocation: initialLocation,
          );
        }
      });
    }
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
    final homeState = ref.watch(dispatcherHomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Packlead'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Salir',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: homeState.when(
        data: (state) => _buildContent(context, state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => HomeScreenError(errorMsg: error.toString(), dispatcherId: widget.dispatcherId),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    final currentLocation = ref.watch(dispatcherCurrentLocationProvider);

    return Stack(
      children: [
        // MAP
        Positioned.fill(
          child: RouteTrackingMap(
            destination: state.selectedOrder?.location,
            selectedOrder: state.selectedOrder,
            currentPosition: currentLocation,
            hqLocation: SRMCHQ,
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
        OrderBottomSheet(dispatcherId: widget.dispatcherId),
      ],
    );
  }
}