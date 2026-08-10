import 'package:firebase_database/firebase_database.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/services/firebase/firebase_rtdb_service.dart';

class DispatcherLocationService {
  final FirebaseRTDBService _rtdbService;
  static const String _locationsPath = 'locations';

  DispatcherLocationService(this._rtdbService);

  /// Register dispatcher in RTDB
  /// happens when dispatcher enters in 'DispatcherHomeScreen' (after login)
  Future<void> registerDispatcher({
    required String dispatcherId,
    required String email,
    required Location initialLocation,
  }) async {
    final dispatcherLocation = DispatcherLocation(
      dispatcherId: dispatcherId,
      email: email,
      lat: initialLocation.lat,
      lng: initialLocation.lng,
      updatedAt: DateTime.now(),
    );

    final path = '$_locationsPath/$dispatcherId';

    await _rtdbService.set(path, dispatcherLocation.toJson());
    await _rtdbService.removeOnDisconnect(path);
  }

  /// Update only the location (lat/lng)
  /// happens each time 'LocationTrackingService' detects a change
  Future<void> updateLocation({
    required String dispatcherId,
    required Location location,
  }) async {
    await _rtdbService.update('$_locationsPath/$dispatcherId', {
      'lat': location.lat,
      'lng': location.lng,
      'updatedAt': ServerValue.timestamp,
    });
  }

  /// Delete dispatcher register in RTDB
  /// happens when 'DispatcherHomeScreen' is disposed (logout/app closed)
  Future<void> unregisterDispatcher(String dispatcherId) async {
    final path = '$_locationsPath/$dispatcherId';

    await _rtdbService.cancelOnDisconnect(path);
    await _rtdbService.remove(path);
  }

  /// Listen changes from ALL dispatchers locations (admin feature)
  Stream<List<DispatcherLocation>> watchAllLocations() {
    return _rtdbService.watch(_locationsPath).map((event) {
      if (event.snapshot.value == null) return <DispatcherLocation>[];

      final data = event.snapshot.value as Map<dynamic, dynamic>;

      return data.entries.map((entry) {
        final locationData = entry.value as Map<dynamic, dynamic>;
        final Map<String, dynamic> locationMap = Map<String, dynamic>.from(
          locationData,
        );

        locationMap['dispatcherId'] = entry.key as String;

        return DispatcherLocation.fromJson(locationMap);
      }).toList();
    });
  }

  /// Obtain the location from an specific dispatcher
  Future<DispatcherLocation?> getDispatcherLocation(String dispatcherId) async {
    final snapshot = await _rtdbService.getOnce(
      '$_locationsPath/$dispatcherId',
    );

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return DispatcherLocation.fromJson(data);
  }

  /// Verify if a dispatcher is online
  Future<bool> isDispatcherOnline(String dispatcherId) async {
    return await _rtdbService.exists('$_locationsPath/$dispatcherId');
  }
}
