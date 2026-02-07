import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_route_provider.dart';

class RouteTrackingMap extends ConsumerStatefulWidget {
  final Location? destination;
  final Order? selectedOrder;
  final Location? currentPosition;
  final double initialZoom;

  const RouteTrackingMap({
    super.key,
    this.destination,
    this.selectedOrder,
    this.currentPosition,
    this.initialZoom = 12.0,
  });

  @override
  ConsumerState<RouteTrackingMap> createState() => _RouteTrackingMapState();
}

class _RouteTrackingMapState extends ConsumerState<RouteTrackingMap> {
  GoogleMapController? _mapController;
  static const LatLng _defaultCenter = LatLng(-0.1807, -78.4678);

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

  // ========================================
  // CALLBACKS
  // ========================================

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _adjustCameraToBounds();
  }

  // ========================================
  // MARKERS
  // ========================================

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // Marker de destino (siempre se muestra si hay destino)
    if (widget.destination != null) {
      markers.add(_buildDestinationMarker(widget.destination!));
    }

    // Marker de origen (solo en modo shipped)
    if (_shouldShowRoute() && widget.currentPosition != null) {
      markers.add(_buildOriginMarker(widget.currentPosition!));
    }

    return markers;
  }

  Marker _buildDestinationMarker(Location destination) {
    return Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(destination.lat, destination.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Destino',
        snippet: widget.selectedOrder?.clientName ?? 'Cliente',
      ),
    );
  }

  Marker _buildOriginMarker(Location origin) {
    return Marker(
      markerId: const MarkerId('origin'),
      position: LatLng(origin.lat, origin.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(
        title: 'Mi Ubicación',
        snippet: 'Punto de partida',
      ),
    );
  }

  // ========================================
  // POLYLINES (RUTAS)
  // ========================================

  Set<Polyline> _buildPolylines() {
    if (!_shouldShowRoute() || widget.selectedOrder == null) {
      return {};
    }

    // Obtener ruta del provider
    final routeAsync = ref.watch(routeProvider(widget.selectedOrder!));

    return routeAsync.when(
      data: (routePoints) => _buildRoutePolyline(routePoints),
      loading: () => {},
      error: (_, __) => {},
    );
  }

  Set<Polyline> _buildRoutePolyline(List<Location> routePoints) {
    if (routePoints.isEmpty) {
      return {};
    }

    // Convertir Location a LatLng
    final points = routePoints.map((loc) => LatLng(loc.lat, loc.lng)).toList();

    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  // ========================================
  // CAMERA CONTROL
  // ========================================

  LatLng _getInitialPosition() {
    // Si hay destino, centrar ahí
    if (widget.destination != null) {
      return LatLng(widget.destination!.lat, widget.destination!.lng);
    }

    // Si hay posición actual, centrar ahí
    if (widget.currentPosition != null) {
      return LatLng(widget.currentPosition!.lat, widget.currentPosition!.lng);
    }

    // Default: centro de Quito
    return _defaultCenter;
  }

  /// Ajusta la cámara para mostrar todos los puntos relevantes
  void _adjustCameraToBounds() {
    if (_mapController == null) return;

    // Si no hay destino, no ajustar
    if (widget.destination == null) return;

    // Si solo hay destino (modo pending)
    if (!_shouldShowRoute() || widget.currentPosition == null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.destination!.lat, widget.destination!.lng),
          14.0,
        ),
      );
      return;
    }

    // Si hay ruta (modo shipped), ajustar para ver origen y destino
    final bounds = _calculateBounds([
      widget.currentPosition!,
      widget.destination!,
    ]);

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80), // 80px de padding
    );
  }

  /// Calcula los límites (bounds) para una lista de ubicaciones
  LatLngBounds _calculateBounds(List<Location> locations) {
    if (locations.isEmpty) {
      return LatLngBounds(
        southwest: _defaultCenter,
        northeast: _defaultCenter,
      );
    }

    double minLat = locations.first.lat;
    double maxLat = locations.first.lat;
    double minLng = locations.first.lng;
    double maxLng = locations.first.lng;

    for (final location in locations) {
      if (location.lat < minLat) minLat = location.lat;
      if (location.lat > maxLat) maxLat = location.lat;
      if (location.lng < minLng) minLng = location.lng;
      if (location.lng > maxLng) maxLng = location.lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // ========================================
  // HELPERS
  // ========================================

  /// Determina si debe mostrar la ruta completa
  /// Solo en modo shipped
  bool _shouldShowRoute() {
    if (widget.selectedOrder == null) return false;
    return widget.selectedOrder!.state == OrderState.shipped;
  }

  // ========================================
  // REACT TO CHANGES
  // ========================================

  @override
  void didUpdateWidget(RouteTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si cambió el destino o la orden seleccionada, ajustar cámara
    if (oldWidget.destination != widget.destination ||
        oldWidget.selectedOrder?.id != widget.selectedOrder?.id) {
      // Delay para asegurar que el mapa esté listo
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _adjustCameraToBounds();
        }
      });
    }
  }
}
