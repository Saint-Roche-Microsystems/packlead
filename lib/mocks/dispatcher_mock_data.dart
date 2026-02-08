import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';

class DispatcherMockData {
  final List<Dispatcher> dispatchers = [
    Dispatcher(
      id: 'disp_001',
      name: 'Carlos Méndez',
      email: 'carlos.disp@packlead.com',
      vehicle: 'Moto Honda CG 150',
      licensePlate: 'PBX-1234',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_002',
      name: 'Ana López',
      email: 'ana.disp@packlead.com',
      vehicle: 'Moto Yamaha FZ 150',
      licensePlate: 'PCQ-5678',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_003',
      name: 'Pedro Martínez',
      email: 'pedro.disp@packlead.com',
      vehicle: 'Moto Suzuki GN 125',
      licensePlate: 'PBA-9012',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_004',
      name: 'María García',
      email: 'maria.disp@packlead.com',
      vehicle: 'Bicicleta Eléctrica',
      licensePlate: 'N/A',
      state: DispatcherState.inactive,
    ),
    Dispatcher(
      id: 'disp_005',
      name: 'Luis Torres',
      email: 'luis.disp@packlead.com',
      vehicle: 'Moto Kawasaki Boxer',
      licensePlate: 'PIB-3456',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_006',
      name: 'Ana Rodríguez',
      email: 'ana.rodriguez@delivery.com',
      vehicle: 'Moto Yamaha FZ',
      licensePlate: 'PCH-5678',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_007',
      name: 'Luis Torres',
      email: 'luis.torres@delivery.com',
      vehicle: 'Moto Suzuki GN',
      licensePlate: 'PGY-9012',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp_008',
      name: 'María Castillo',
      email: 'maria.castillo@delivery.com',
      vehicle: 'Moto Kawasaki Boxer',
      licensePlate: 'PIM-3456',
      state: DispatcherState.inactive,
    ),
    Dispatcher(
      id: 'disp_009',
      name: 'Jorge Sánchez',
      email: 'jorge.sanchez@delivery.com',
      vehicle: 'Moto Honda Wave',
      licensePlate: 'PLT-7890',
      state: DispatcherState.inactive,
    ),
  ];
}