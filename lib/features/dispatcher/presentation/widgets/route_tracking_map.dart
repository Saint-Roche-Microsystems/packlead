import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/core/utils/marker_builder.dart';
import 'package:packlead/core/utils/polyline_builder.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_route_provider.dart';

class RouteTrackingMap extends ConsumerStatefulWidget {
  final Location? destination;
  final Order? selectedOrder;
  final Location? currentPosition;
  final Location hqLocation;
  final double initialZoom;

  const RouteTrackingMap({
    super.key,
    this.destination,
    this.selectedOrder,
    this.currentPosition,
    required this.hqLocation,
    this.initialZoom = 13.0,
  });

  @override
  ConsumerState<RouteTrackingMap> createState() => _RouteTrackingMapState();
}

class _RouteTrackingMapState extends ConsumerState<RouteTrackingMap> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _getInitialPosition(),
        zoom: widget.initialZoom,
      ),
      onMapCreated: _onMapCreated,
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      compassEnabled: true,
      buildingsEnabled: true,
      trafficEnabled: false,
    );
  }

  // Adjust camera when map is first created
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _adjustCameraToBounds();
  }

  // MARKERS
  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // HQ marker - always visible
    markers.add(MarkerBuilder.buildHqLocationMarker(widget.hqLocation.toLatLng()));

    // Marker de ubicación actual del dispatcher - si está disponible
    if (widget.currentPosition != null) {
      markers.add(MarkerBuilder.buildCurrentPositionMarker(widget.currentPosition!));
    }

    // Destionation marker, only show if it is selected
    if (widget.destination != null) {
      markers.add(MarkerBuilder.buildDestinationMarker(
        widget.destination!.toLatLng(),
        widget.selectedOrder?.clientName,
      ));
    }

    return markers;
  }

  // POLYLINES
  Set<Polyline> _buildPolylines() {
    if (!_shouldShowRoute() || widget.selectedOrder == null) {
      return {};
    }

    // Get route points from provider
    final routeAsync = ref.watch(routeProvider(widget.selectedOrder!));

    return routeAsync.when(
      data: (routePoints) => PolylineBuilder.buildRoutePolylineSet(
        routePoints,
        color: SaintColors.primary,
        width: 5,
      ),
      loading: () => {},
      error: (_, __) => {},
    );
  }

  // CAMERA CONTROL
  LatLng _getInitialPosition() {
    // Center around destination if available
    if (widget.destination != null) {
      return widget.destination!.toLatLng();
    }

    // Center around current position if available
    if (widget.currentPosition != null) {
      return widget.currentPosition!.toLatLng();
    }

    // Default: center at HQ
    return widget.hqLocation.toLatLng();
  }

  void _adjustCameraToBounds() {
    if (_mapController == null) return;

    // Center around HQ or current location if no destination is available
    if (widget.destination == null) {
      final centerPosition = widget.currentPosition ?? widget.hqLocation;
      final cameraUpdate = MapUtils.focusOnLocation(centerPosition, zoom: 14.0);
      _mapController!.animateCamera(cameraUpdate);
      return;
    }

    // Center around destination if order is pending state
    if (!_shouldShowRoute()) {
      final cameraUpdate = MapUtils.focusOnLocation(widget.destination!, zoom: 14.0);
      _mapController!.animateCamera(cameraUpdate);
      return;
    }

    // If there is a route (shipping state), adjust to see the HQ and destination
    // INFO: Route always includes HQ as the origin
    final cameraUpdate = MapUtils.focusOnRoute(
      origin: widget.hqLocation,
      destination: widget.destination!,
      padding: 80.0,
    );

    _mapController!.animateCamera(cameraUpdate);
  }

  /// Check if the selected order is in "shipped" state
  bool _shouldShowRoute() {
    if (widget.selectedOrder == null) return false;
    return widget.selectedOrder!.state == OrderState.shipped;
  }

  @override
  void didUpdateWidget(RouteTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Adjust camera if destination or selected order changes
    if (oldWidget.destination != widget.destination ||
        oldWidget.selectedOrder?.id != widget.selectedOrder?.id) {
      // Delay the map to ensure marker updates
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _adjustCameraToBounds();
        }
      });
    }
  }
}
