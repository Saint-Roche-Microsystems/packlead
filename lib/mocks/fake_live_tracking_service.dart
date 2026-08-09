import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:packlead/core/models/dispatcher_location.dart';

/// Demo-only fake data for the admin Dashboard/Tracking Map when running
/// with MOCK data
class FakeLiveTrackingService {
  FakeLiveTrackingService._();

  // Fallback used if the device denies/lacks GPS (e.g. an emulator with
  // location services off). Arbitrary fixed coordinate, no real meaning
  static const double _fallbackLat = 9.9281;
  static const double _fallbackLng = -84.0907;

  static final _random = Random();

  static const _fakeNames = [
    'Alfonso Montejo',
    'Edgar Chable',
    'Silvina Benavides',
    'Jessica Morales',
    'Michel Loza',
  ];

  static Future<List<DispatcherLocation>> generate() async {
    final origin = await _resolveOrigin();
    final count = 1 + _random.nextInt(5); // 1-5 inclusive

    return List.generate(count, (index) {
      // First marker sits exactly on the device's location; the rest are
      // jittered randomly around it (~0-1.5km)
      final isOrigin = index == 0;
      final offsetLat = isOrigin ? 0.0 : (_random.nextDouble() - 0.5) * 0.02;
      final offsetLng = isOrigin ? 0.0 : (_random.nextDouble() - 0.5) * 0.02;

      return DispatcherLocation(
        dispatcherId: 'mock-dispatcher-$index',
        email: _fakeNames[index % _fakeNames.length],
        lat: origin.latitude + offsetLat,
        lng: origin.longitude + offsetLng,
        updatedAt: DateTime.now(),
      );
    });
  }

  static Future<Position> _resolveOrigin() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return _fallbackPosition();

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _fallbackPosition();
      }

      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return _fallbackPosition();
    }
  }

  static Position _fallbackPosition() {
    return Position(
      latitude: _fallbackLat,
      longitude: _fallbackLng,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
