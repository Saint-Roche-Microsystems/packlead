import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/srmc_hq.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_route_provider.dart';
import 'package:packlead/features/dispatcher/presentation/screens/home_screen_error.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/order_bottom_sheet.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/route_tracking_map.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/status_tracking_badge.dart';
import 'package:packlead/navigation/routers/auth_router.dart';
import 'package:packlead/services/mock_services/mock_auth_service.dart';

class DispatcherHomeScreen extends ConsumerStatefulWidget {
  final String dispatcherId;

  const DispatcherHomeScreen({super.key, required this.dispatcherId});

  @override
  ConsumerState<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends ConsumerState<DispatcherHomeScreen> {
  bool _hasInitializedTracking = false;

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(locationTrackingServiceProvider).startTracking();
        }
      });
    }
  }

  @override
  void dispose() {
    // Stop tracking service when leaving the screen
    if (mounted) {
      ref.read(locationTrackingServiceProvider).stopTracking();
    }
    ref.read(dispatcherHomeProvider.notifier).reset();
    super.dispose();
  }

  void _logout(BuildContext context) {
    MockAuthService.logout();
    Navigator.pushReplacementNamed(context, AuthRouter.login);
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
            onPressed: () => _logout(context),
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