import 'package:packlead/core/models/dispatcher.dart';

abstract class DispatcherDatasource {
  Future<List<Dispatcher>> getAllDispatchers();
  Future<List<Dispatcher>> getAvailableDispatchers();
  Future<Dispatcher> getDispatcherById(String id);
  Future<Dispatcher> createDispatcher(Dispatcher dispatcher);
  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher);
  Future<void> deleteDispatcher(String id);
}