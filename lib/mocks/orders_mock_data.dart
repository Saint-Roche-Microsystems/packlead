import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';

class OrdersMockData {
  final List<Order> orders = [
    Order(
      id: 'order_001',
      dispatcherId: 'disp_001',
      clientName: 'Juan Pérez',
      clientPhoneNumber: '+593987654321',
      location: Location(lat: -0.1807, lng: -78.4678),
      address: 'Av. Amazonas N24-03 y Colón',
      state: OrderState.shipped, // ← EN RUTA
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 7, 14, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 8, 30),
    ),
    Order(
      id: 'order_002',
      dispatcherId: 'disp_001',
      clientName: 'María González',
      clientPhoneNumber: '+593987654322',
      location: Location(lat: -0.1950, lng: -78.4800),
      address: 'Av. 6 de Diciembre N34-120',
      state: OrderState.pending,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 7, 16, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 9, 0),
    ),

    Order(
      id: 'order_003',
      dispatcherId: 'disp_001',
      clientName: 'Carlos Ruiz',
      clientPhoneNumber: '+593987654323',
      location: Location(lat: -0.2100, lng: -78.4900),
      address: 'Calle Los Shyris N45-67',
      state: OrderState.pending,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 7, 18, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 9, 30),
    ),
    Order(
      id: 'order_004',
      dispatcherId: 'disp_001',
      clientName: 'Ana Morales',
      clientPhoneNumber: '+593987654324',
      location: Location(lat: -0.1700, lng: -78.4600),
      address: 'Av. Naciones Unidas E7-25',
      state: OrderState.delivered,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 6, 15, 0), // Ayer
      createdAt: DateTime(2026, 2, 6, 8, 0),
    ),
    Order(
      id: 'order_005',
      dispatcherId: 'disp_002',
      clientName: 'Pedro Jiménez',
      clientPhoneNumber: '+593987654325',
      location: Location(lat: -0.2500, lng: -78.5200),
      address: 'Av. La Prensa N52-123',
      state: OrderState.pending,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 7, 10, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 7, 0),
    ),

    Order(
      id: 'order_006',
      dispatcherId: 'disp_002',
      clientName: 'Laura Vásquez',
      clientPhoneNumber: '+593987654326',
      location: Location(lat: -0.2700, lng: -78.5400),
      address: 'Av. Maldonado S23-45',
      state: OrderState.pending,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 7, 13, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 7, 30),
    ),

    Order(
      id: 'order_007',
      dispatcherId: 'disp_002',
      clientName: 'Roberto Castillo',
      clientPhoneNumber: '+593987654327',
      location: Location(lat: -0.2900, lng: -78.5600),
      address: 'Calle Quitumbe Ñan S31-78',
      state: OrderState.pending,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 7, 15, 30), // Hoy
      createdAt: DateTime(2026, 2, 7, 8, 0),
    ),

    Order(
      id: 'order_008',
      dispatcherId: 'disp_002',
      clientName: 'Sofía Ramírez',
      clientPhoneNumber: '+593987654328',
      location: Location(lat: -0.2400, lng: -78.5100),
      address: 'Av. Mariscal Sucre S19-90',
      state: OrderState.delivered,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 6, 11, 0), // Ayer
      createdAt: DateTime(2026, 2, 6, 7, 0),
    ),
    Order(
      id: 'order_009',
      dispatcherId: 'disp_003',
      clientName: 'Diego Fernández',
      clientPhoneNumber: '+593987654329',
      location: Location(lat: -0.1200, lng: -78.5000),
      address: 'Av. Eloy Alfaro N35-210',
      state: OrderState.shipped, // ← EN RUTA
      zone: 'Centro',
      deliveryDate: DateTime(2026, 2, 7, 11, 30), // Hoy
      createdAt: DateTime(2026, 2, 7, 8, 0),
    ),

    Order(
      id: 'order_010',
      dispatcherId: 'disp_003',
      clientName: 'Claudia Torres',
      clientPhoneNumber: '+593987654330',
      location: Location(lat: -0.1400, lng: -78.5100),
      address: 'Calle Venezuela N8-42',
      state: OrderState.pending,
      zone: 'Centro',
      deliveryDate: DateTime(2026, 2, 7, 17, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 9, 0),
    ),
    Order(
      id: 'order_011',
      dispatcherId: 'disp_003',
      clientName: 'Fernando Ríos',
      clientPhoneNumber: '+593987654331',
      location: Location(lat: -0.1300, lng: -78.5050),
      address: 'Av. 10 de Agosto N26-98',
      state: OrderState.delivered,
      zone: 'Centro',
      deliveryDate: DateTime(2026, 2, 6, 12, 0), // Ayer
      createdAt: DateTime(2026, 2, 6, 8, 0),
    ),
    Order(
      id: 'order_012',
      dispatcherId: 'disp_003',
      clientName: 'Patricia Herrera',
      clientPhoneNumber: '+593987654332',
      location: Location(lat: -0.1500, lng: -78.5150),
      address: 'Calle García Moreno S1-67',
      state: OrderState.delivered,
      zone: 'Centro',
      deliveryDate: DateTime(2026, 2, 5, 14, 0), // Hace 2 días
      createdAt: DateTime(2026, 2, 5, 8, 30),
    ),
    Order(
      id: 'order_013',
      dispatcherId: 'disp_005',
      clientName: 'Ricardo Mendoza',
      clientPhoneNumber: '+593987654333',
      location: Location(lat: -0.0900, lng: -78.4400),
      address: 'Av. De Los Granados E12-45',
      state: OrderState.pending,
      zone: 'Valle',
      deliveryDate: DateTime(2026, 2, 7, 12, 0), // Hoy
      createdAt: DateTime(2026, 2, 7, 7, 30),
    ),

    Order(
      id: 'order_014',
      dispatcherId: 'disp_005',
      clientName: 'Gabriela Suárez',
      clientPhoneNumber: '+593987654334',
      location: Location(lat: -0.1000, lng: -78.4500),
      address: 'Calle De Los Arrayanes N44-12',
      state: OrderState.pending,
      zone: 'Valle',
      deliveryDate: DateTime(2026, 2, 7, 16, 30), // Hoy
      createdAt: DateTime(2026, 2, 7, 8, 30),
    ),
    Order(
      id: 'order_015',
      dispatcherId: 'disp_005',
      clientName: 'Andrés Vargas',
      clientPhoneNumber: '+593987654335',
      location: Location(lat: -0.0800, lng: -78.4300),
      address: 'Av. Interoceánica Km 12.5',
      state: OrderState.delivered,
      zone: 'Valle',
      deliveryDate: DateTime(2026, 2, 6, 13, 0), // Ayer
      createdAt: DateTime(2026, 2, 6, 8, 0),
    ),
    Order(
      id: 'order_016',
      dispatcherId: null,
      clientName: 'Verónica Campos',
      clientPhoneNumber: '+593987654336',
      location: Location(lat: -0.1600, lng: -78.4700),
      address: 'Av. Portugal N34-56',
      state: OrderState.pending,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 8, 10, 0), // Mañana
      createdAt: DateTime(2026, 2, 7, 10, 0),
    ),
    Order(
      id: 'order_017',
      dispatcherId: null,
      clientName: 'Javier Delgado',
      clientPhoneNumber: '+593987654337',
      location: Location(lat: -0.2200, lng: -78.5000),
      address: 'Av. Occidental N67-89',
      state: OrderState.pending,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 8, 14, 0), // Mañana
      createdAt: DateTime(2026, 2, 7, 10, 30),
    ),
  ];
}