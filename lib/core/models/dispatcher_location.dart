import 'package:packlead/core/models/location.dart';

// model specific for RTDB
class DispatcherLocation {
  final String dispatcherId;
  final String email;
  final double lat;
  final double lng;
  final DateTime updatedAt;

  DispatcherLocation({
    required this.dispatcherId,
    required this.email,
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });

  // convert DispatcherLocation to Location
  Location toLocation() {
    return Location(lat: lat, lng: lng);
  }

  // convert a list of DispatcherLocation to a list of Location
  static List<Location> toLocations(List<DispatcherLocation> dispatcherLocations) {
    return dispatcherLocations.map((dl) => dl.toLocation()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'lat': lat,
      'lng': lng,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DispatcherLocation.fromJson(Map<String, dynamic> json) {
    return DispatcherLocation(
      dispatcherId: json['dispatcherId'] as String? ?? '',
      email: json['email'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updatedAt'] as int,
      ),
    );
  }

  @override
  String toString() {
    return 'DispatcherLocation(id: $dispatcherId, email: $email, lat: $lat, lng: $lng)';
  }
}
