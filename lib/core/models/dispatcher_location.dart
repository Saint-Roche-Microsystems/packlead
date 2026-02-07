import 'package:packlead/core/models/location.dart';

/// Modelo específico para ubicaciones en Firebase RTDB
class DispatcherLocation {
  final String dispatcherId;
  final String name;
  final double lat;
  final double lng;
  final DateTime updatedAt;

  DispatcherLocation({
    required this.dispatcherId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });

  Location toLocation() {
    return Location(lat: lat, lng: lng);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DispatcherLocation.fromJson(Map<String, dynamic> json) {
    return DispatcherLocation(
      dispatcherId: json['dispatcherId'] as String? ?? '',
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updatedAt'] as int,
      ),
    );
  }

  @override
  String toString() {
    return 'DispatcherLocation(id: $dispatcherId, name: $name, lat: $lat, lng: $lng)';
  }
}