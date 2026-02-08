import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:packlead/core/models/location.dart';


class LocationTrackingService {
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _periodicTimer;
  Position? _lastPosition;
  final void Function(Location location) onLocationUpdate;
  final void Function(String error)? onError;

  LocationTrackingService({
    required this.onLocationUpdate,
    this.onError,
  });

  Future<void> startTracking() async {
    if (_positionStreamSubscription != null || _periodicTimer != null) {
      return;
    }

    try {
      final hasPermission = await _checkPermissions();
      if (!hasPermission) {
        onError?.call('Permisos de ubicación denegados');
        return;
      }

      await _getCurrentLocation();

      // Periodic location updates every 5 seconds
      _periodicTimer = Timer.periodic(
        const Duration(seconds: 5),
            (_) => _getCurrentLocation(),
      );
    } catch (e) {
      onError?.call('Error al iniciar tracking: $e');
    }
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _lastPosition = null;
  }

  /// Get the device location
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Verify minimum distance change
      if (_lastPosition != null) {
        final distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        // Ignore if the change is less than 10 meters
        if (distance < 10) {
          return;
        }
      }

      // Update last position
      _lastPosition = position;

      // Notify location update
      final location = Location(
        lat: position.latitude,
        lng: position.longitude,
      );

      onLocationUpdate(location);
    } catch (e) {
      onError?.call('Error al obtener ubicación');
    }
  }

  Future<bool> _checkPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onError?.call('Servicio de ubicación deshabilitado');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      onError?.call('Permisos de ubicación denegados permanentemente');
      return false;
    }

    return true;
  }

  /// Verify if the tracking is active
  bool get isTracking => _periodicTimer != null && _periodicTimer!.isActive;

  void dispose() {
    stopTracking();
  }
}