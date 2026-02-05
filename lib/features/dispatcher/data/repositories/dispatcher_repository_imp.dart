import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';

class DispatcherRepositoryImp implements DispatcherRepository {
  final DispatcherDatasource _dataSource;

  DispatcherRepositoryImp(this._dataSource);

  @override
  Future<List<Dispatcher>> getAllDispatchers() async {
    try{
      return await _dataSource.getAllDispatchers();
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<Dispatcher>> getAvailableDispatchers() async {
    try{
      return await _dataSource.getAvailableDispatchers();
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<Dispatcher> createDispatcher(Dispatcher dispatcher) async {
    try{
      return await _dataSource.createDispatcher(dispatcher);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher) async {
    try{
      return await _dataSource.updateDispatcher(dispatcher);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDispatcher(String id) async{
    try{
      return await _dataSource.deleteDispatcher(id);
    } catch(e) {
      rethrow;
    }
  }
}