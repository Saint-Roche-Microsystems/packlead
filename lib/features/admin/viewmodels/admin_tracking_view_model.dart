import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/models/location.dart';

/// Joins a live RTDB [DispatcherLocation] (keyed by Firebase UID) with its
/// matching backend [Dispatcher] record (via `Dispatcher.firebaseUid`)
class AdminTrackingViewModel {
  final String firebaseUid;
  final String name;
  final double lat;
  final double lng;
  final DateTime updatedAt;

  // Data only available once joined with the backend dispatcher record
  final String? dispatcherId;
  final String? vehicle;
  final String? licensePlate;

  AdminTrackingViewModel({
    required this.firebaseUid,
    required this.name,
    required this.lat,
    required this.lng,
    required this.updatedAt,
    this.dispatcherId,
    this.vehicle,
    this.licensePlate,
  });

  factory AdminTrackingViewModel.fromLocation(DispatcherLocation location, Dispatcher? dispatcher) {
    return AdminTrackingViewModel(
      firebaseUid: location.dispatcherId,
      name: dispatcher?.name ?? location.email,
      lat: location.lat,
      lng: location.lng,
      updatedAt: location.updatedAt,
      dispatcherId: dispatcher?.id,
      vehicle: dispatcher?.vehicle,
      licensePlate: dispatcher?.licensePlate,
    );
  }

  Location toLocation() => Location(lat: lat, lng: lng);

  static List<Location> toLocations(List<AdminTrackingViewModel> viewModels) {
    return viewModels.map((vm) => vm.toLocation()).toList();
  }
}
