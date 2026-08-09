import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/utils/app_logger.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/features/dispatcher/models/dispatcher_creation_result.dart';
import 'package:packlead/services/api/clients/dispatchers_api_client.dart';

class DispatcherApiDataSource implements DispatcherDatasource {
  final DispatchersApiClient _apiClient;

  DispatcherApiDataSource(this._apiClient);

  @override
  Future<List<Dispatcher>> getAllDispatchers() async {
    try {
      return await _apiClient.getDispatchers();
    } catch (e, st) {
      AppLogger.error('Error al obtener todos los repartidores', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<Dispatcher>> getDispatchersByState(DispatcherState state) async {
    try {
      final dispatchers = await _apiClient.getDispatchers();
      return dispatchers.where((dispatcher) => dispatcher.state == state).toList();
    } catch (e, st) {
      AppLogger.error('Error al obtener repartidores por estado', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Dispatcher> getDispatcherById(String id) async {
    try {
      return await _apiClient.getDispatcher(id);
    } catch (e, st) {
      AppLogger.error('Error al obtener repartidor por ID', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Dispatcher> getMyProfile() async {
    try {
      return await _apiClient.getMyProfile();
    } catch (e, st) {
      AppLogger.error('Error al obtener el perfil del repartidor', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DispatcherCreationResult> createDispatcher(Dispatcher dispatcher) async {
    try {
      final payload = dispatcher.toJson();
      final data = await _apiClient.createDispatcher(payload);

      return DispatcherCreationResult(
        dispatcher: Dispatcher.fromJson(data),
        passwordResetLink: data['passwordResetLink'] as String?,
      );
    } catch (e, st) {
      AppLogger.error('Error al crear repartidor', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher) async {
    try {
      final payload = dispatcher.toJson();
      return await _apiClient.updateDispatcher(dispatcher.id, payload);
    } catch (e, st) {
      AppLogger.error('Error al actualizar repartidor', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteDispatcher(String id) async {
    try {
      await _apiClient.deleteDispatcher(id);
    } catch (e, st) {
      AppLogger.error('Error al eliminar repartidor', error: e, stackTrace: st);
      rethrow;
    }
  }
}
