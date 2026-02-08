import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/utils/color_utils.dart';

class MarkerBuilder {
  MarkerBuilder._();

  /// Marker for a selected location
  static Marker buildSelectedLocationMarker(LatLng location) {
    return Marker(
      markerId: const MarkerId('selected'),
      position: location,
      draggable: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  // Marker for destionation location
  static Marker buildDestinationMarker(LatLng location, String? clientName) {
    return Marker(
      markerId: const MarkerId('destination'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Destino',
        snippet: clientName ?? 'Cliente',
      ),
    );
  }

  /// Marker for the headquarters location
  static Marker buildHqLocationMarker(LatLng location) {
    return Marker(
      markerId: const MarkerId('srmc_hq'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: 'SRMC - HQ',
        snippet: 'Bodega',
      ),
    );
  }

  /// Marker for the current position with direction
  static Marker buildCurrentPositionMarker(
      Location location, {
        double? heading,
      }) {
    return Marker(
      markerId: const MarkerId('current'),
      position: location.toLatLng(),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      rotation: heading ?? 0,
      anchor: const Offset(0.5, 0.5),
    );
  }


  // Custom marker icon with dispatcher initials
  static Future<BitmapDescriptor> createMarkerIconInitials(
      String name, {
        double size = 45,
        Color? color,
      }) async {
    final String initials = _getInitials(name);
    final Color markerColor = color ?? ColorUtils.getRandomColor();
    final Color backgroundColor = markerColor.withValues(alpha: 0.2);

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();

    // Background circle with opacity
    paint.color = backgroundColor;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // Interior circle with solid color
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2.5,
      paint,
    );

    // Interior circle border
    paint.color = markerColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2.5,
      paint,
    );

    // Draw initials
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: initials,
      style: TextStyle(
        fontSize: size / 3,
        fontWeight: FontWeight.bold,
        color: markerColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    // Convert into image
    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }


  // Get initials helper
  static String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    String initials = '';

    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0].toUpperCase();
      if (nameParts.length > 1) {
        initials += nameParts[nameParts.length - 1][0].toUpperCase();
      }
    }

    return initials;
  }
}