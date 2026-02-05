import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';

class OrderRepositoryImp implements OrderRepository {
  final OrderDataSource _dataSource;

  OrderRepositoryImp(this._dataSource);

  @override
  Future<List<Order>> getAllOrders() async {
    try{
      return await _dataSource.getAllOrders();
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByDispatcher(String dispatcherId) async {
    try{
      return await _dataSource.getOrdersByDispatcher(dispatcherId);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<Order> updateOrder(Order order) async {
    try{
      return await _dataSource.updateOrder(order);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<Order> createOrder(Order order) async {
    try{
      return await _dataSource.createOrder(order);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    try{
      return await _dataSource.deleteOrder(id);
    } catch(e) {
      rethrow;
    }
  }
}