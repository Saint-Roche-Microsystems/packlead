import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';

abstract class DispatcherRepository {
  Future<List<Dispatcher>> getAllDispatchers();
  Future<List<Dispatcher>> getDispatchersByState(DispatcherState state);
  Future<Dispatcher> getDispatcherById(String id);
  Future<Dispatcher> createDispatcher(Dispatcher dispatcher);
  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher);
  Future<void> deleteDispatcher(String id);
}