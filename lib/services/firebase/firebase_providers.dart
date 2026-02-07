import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/services/firebase/dispatcher_location_service.dart';
import 'package:packlead/services/firebase/firebase_rtdb_service.dart';

/// Generic provier for RTDB service
final firebaseRTDBServiceProvider = Provider<FirebaseRTDBService>((ref) {
  return FirebaseRTDBService();
});

/// Provider for dispatchers location service
final dispatcherLocationServiceProvider = Provider<DispatcherLocationService>((ref) {
  final rtdbService = ref.watch(firebaseRTDBServiceProvider);
  return DispatcherLocationService(rtdbService);
});