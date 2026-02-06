import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  LatLng toLatLng() => LatLng(lat, lng);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;

  @override
  String toString() => 'Location(lat: $lat, lng: $lng)';
}