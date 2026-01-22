import 'package:packlead/core/models/location.dart';

class Order {
  final String id;
  final String? dispatcherId;

  final String? dispatcherName;
  final String client;
  final String phoneNumber;
  final Location location;
  final String? address;
  final String state;
  final String zone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? assignedAt;
  final DateTime? deliveredAt;

  Order({
    required this.id,
    required this.client,
    required this.phoneNumber,
    required this.location,
    required this.state,
    required this.zone,
    required this.createdAt,
    required this.updatedAt,
    this.dispatcherId,
    this.dispatcherName,
    this.address,
    this.assignedAt,
    this.deliveredAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as Map<String, dynamic>?;

    return Order(
      id: json['orderId'] as String? ?? '',
      dispatcherId: json['dispatcherId'] as String?,
      dispatcherName: json['dispatcherName'] as String?,
      client: json['client'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      location: locationJson != null
          ? Location.fromJson(locationJson)
          : Location(lat: 0, lng: 0),
      address: json['address'] as String?,
      state: json['state'] as String? ?? '',
      zone: json['zone'] as String? ?? '',
      createdAt: _parseDate(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      assignedAt: _parseDate(json['assignedAt']),
      deliveredAt: _parseDate(json['deliveredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': id,
      'dispatcherId': dispatcherId,
      'dispatcherName': dispatcherName,
      'client': client,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'address': address,
      'state': state,
      'zone': zone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedAt': assignedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    return DateTime.tryParse(value.toString())?.toUtc();
  }
}