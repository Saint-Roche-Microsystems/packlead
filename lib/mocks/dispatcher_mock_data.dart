import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';

class DispatcherMockData {
  final List<Dispatcher> dispatchers = [
    Dispatcher(
      id: 'disp-1',
      name: 'Carlos Méndez',
      email: 'carlos.mendez@delivery.com',
      vehicle: 'Moto Honda CG 150',
      licensePlate: 'PBX-1234',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp-2',
      name: 'Ana Rodríguez',
      email: 'ana.rodriguez@delivery.com',
      vehicle: 'Moto Yamaha FZ',
      licensePlate: 'PCH-5678',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp-3',
      name: 'Luis Torres',
      email: 'luis.torres@delivery.com',
      vehicle: 'Moto Suzuki GN',
      licensePlate: 'PGY-9012',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp-4',
      name: 'María Castillo',
      email: 'maria.castillo@delivery.com',
      vehicle: 'Moto Kawasaki Boxer',
      licensePlate: 'PIM-3456',
      state: DispatcherState.inactive,
    ),
    Dispatcher(
      id: 'disp-5',
      name: 'Jorge Sánchez',
      email: 'jorge.sanchez@delivery.com',
      vehicle: 'Moto Honda Wave',
      licensePlate: 'PLT-7890',
      state: DispatcherState.inactive,
    ),
  ];
}