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
}