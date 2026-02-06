import 'package:packlead/core/constants/dispatcher_state.dart';

class Dispatcher {
  final String id;
  final String name;
  final String email;
  final String vehicle;
  final String licensePlate;
  final DispatcherState state;

  Dispatcher({
    required this.id,
    required this.name,
    required this.email,
    required this.vehicle,
    required this.licensePlate,
    required this.state,
  });

  /// Constructor para procesos de creación (ej: formularios)
  Dispatcher.create({
    required this.name,
    required this.email,
    required this.vehicle,
    required this.licensePlate,
  })  : id = '',                           // Temporal, backend lo asigna
        state = DispatcherState.available; // Estado por default en la creación

  /// Deserialización JSON
  factory Dispatcher.fromJson(Map<String, dynamic> json) {
    return Dispatcher(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      vehicle: json['vehicle'] as String,
      licensePlate: json['licensePlate'] as String,
      state: DispatcherStateExtension.fromJson(json['state'] as String),
    );
  }

  /// Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'email': email,
      'vehicle': vehicle,
      'licensePlate': licensePlate,
      'state': state.name,
    };
  }

  // Crear copias
  Dispatcher copyWith({
    String? id,
    String? name,
    String? email,
    String? vehicle,
    String? licensePlate,
    DispatcherState? state,
  }) {
    return Dispatcher(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      vehicle: vehicle ?? this.vehicle,
      licensePlate: licensePlate ?? this.licensePlate,
      state: state ?? this.state,
    );
  }

  // UTILITIES
  @override
  String toString() {
    return 'Dispatcher(id: $id, name: $name, email: $email, vehicle: $vehicle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dispatcher &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.vehicle == vehicle &&
        other.licensePlate == licensePlate &&
        other.state == state;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    vehicle.hashCode ^
    licensePlate.hashCode ^
    state.hashCode;
  }
}