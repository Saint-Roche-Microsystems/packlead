import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';

class AdminOrdersViewModel {
  final String id;
  final String clientName;
  final String clientPhoneNumber;
  final Location location;
  final String? address;
  final OrderState state;
  final String zone;
  final DateTime deliveryDate;
  final DateTime createdAt;

  // Data for UI
  final String? dispatcherId;
  final String? dispatcherName;

  AdminOrdersViewModel({
    required this.id,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.location,
    this.address,
    required this.state,
    required this.zone,
    required this.deliveryDate,
    required this.createdAt,
    this.dispatcherId,
    this.dispatcherName,
  });

  // When we get an Order we build the AdminOrderVM (add extra dispatcher data)
  factory AdminOrdersViewModel.fromOrder(Order order, Dispatcher? dispatcher) {
    return AdminOrdersViewModel(
      id: order.id,
      clientName: order.clientName,
      clientPhoneNumber: order.clientPhoneNumber,
      location: order.location,
      address: order.address,
      state: order.state,
      zone: order.zone,
      deliveryDate: order.deliveryDate,
      createdAt: order.createdAt,
      dispatcherId: order.dispatcherId,
      dispatcherName: dispatcher?.name,
    );
  }

  /// Helper: Show Dispatcher name in UI
  String get displayDispatcherName {
    return dispatcherName ?? 'Dispatcher #$dispatcherId';
  }
}