import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BaseMap extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;
  final Function(CameraPosition)? onCameraMove;
  final bool isInteractive;
  final bool showMyLocationButton;
  final bool myLocationEnabled;
  final String? mapStyle;

  const BaseMap({
    super.key,
    required this.initialPosition,
    this.initialZoom = 14.0,
    this.markers = const {},
    this.polylines = const {},
    this.onMapCreated,
    this.onTap,
    this.onCameraMove,
    this.isInteractive = true,
    this.showMyLocationButton = false,
    this.myLocationEnabled = false,
    this.mapStyle,
  });

  @override
  State<BaseMap> createState() => _BaseMapState();
}

class _BaseMapState extends State<BaseMap> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: widget.initialZoom,
      ),
      style: widget.mapStyle,
      markers: widget.markers,
      polylines: widget.polylines,
      onTap: widget.isInteractive ? widget.onTap : null,
      onCameraMove: widget.onCameraMove,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.showMyLocationButton,
      zoomControlsEnabled: widget.isInteractive,
      scrollGesturesEnabled: widget.isInteractive,
      zoomGesturesEnabled: widget.isInteractive,
      tiltGesturesEnabled: widget.isInteractive,
      rotateGesturesEnabled: widget.isInteractive,
      mapToolbarEnabled: false,
      compassEnabled: widget.isInteractive,
    );
  }
}
