import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/utils/date_formatter.dart';

class Order {
  final String id;
  final String? dispatcherId;
  final String clientName;
  final String clientPhoneNumber;
  final Location location;
  final String? address;
  final OrderState state;
  final String zone;
  final DateTime deliveryDate;
  final DateTime createdAt;

  Order({
    required this.id,
    this.dispatcherId,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.location,
    this.address,
    required this.state,
    required this.zone,
    required this.deliveryDate,
    required this.createdAt,
  });

  /// Constructor para procesos de creación (ej: formularios)
  Order.create({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.location,
    this.address,
    this.dispatcherId,
    required this.zone,
    required this.deliveryDate,
  })  : id = '',                    // Temporal, backend lo asigna
        state = OrderState.pending, // Estado por default en la creación
        createdAt = DateTime.now(); // Temporal, backend lo reemplaza

  /// Deserialización JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      dispatcherId: json['dispatcherId'] as String?,
      clientName: json['clientName'] as String,
      clientPhoneNumber: json['clientPhoneNumber'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
      state: OrderStateExtension.fromJson(json['state'] as String),
      zone: json['zone'] as String,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'dispatcherId': dispatcherId,
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'location': location.toJson(),
      'address': address,
      'state': state.name,
      'zone': zone,
      'deliveryDate': DateFormatter.formatForBackend(deliveryDate),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crear copias
  Order copyWith({
    String? id,
    String? dispatcherId,
    String? clientName,
    String? clientPhoneNumber,
    Location? location,
    String? address,
    OrderState? state,
    String? zone,
    DateTime? deliveryDate,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      dispatcherId: dispatcherId ?? this.dispatcherId,
      clientName: clientName ?? this.clientName,
      clientPhoneNumber: clientPhoneNumber ?? this.clientPhoneNumber,
      location: location ?? this.location,
      address: address ?? this.address,
      state: state ?? this.state,
      zone: zone ?? this.zone,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // UTILITIES
  @override
  String toString() {
    return 'Order(id: $id, clientName: $clientName, state: $state, zone: $zone, deliveryDate: $deliveryDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.id == id &&
        other.dispatcherId == dispatcherId &&
        other.clientName == clientName &&
        other.clientPhoneNumber == clientPhoneNumber &&
        other.location == location &&
        other.address == address &&
        other.state == state &&
        other.zone == zone &&
        other.deliveryDate == deliveryDate &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    dispatcherId.hashCode ^
    clientName.hashCode ^
    clientPhoneNumber.hashCode ^
    location.hashCode ^
    address.hashCode ^
    state.hashCode ^
    zone.hashCode ^
    deliveryDate.hashCode ^
    createdAt.hashCode;
  }
}