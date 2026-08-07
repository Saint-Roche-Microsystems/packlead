import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/services/api/base/api_exception.dart';
import 'package:packlead/services/api/base/base_api_client.dart';

class DispatchersApiClient {
  final BaseApiClient _client;

  DispatchersApiClient(this._client);

  /// GET /dispatchers (admin)
  Future<List<Dispatcher>> getDispatchers() async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/dispatchers');
      return _parseDispatcherList(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error al obtener dispatchers: $e');
    }
  }

  /// GET /dispatchers/:id (admin)
  Future<Dispatcher> getDispatcher(String dispatcherId) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError('Dispatcher ID es requerido');
    }

    try {
      final response = await _client.get<Map<String, dynamic>>('/dispatchers/$dispatcherId');
      return _parseDispatcher(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error al obtener dispatcher: $e');
    }
  }

  /// POST /dispatchers (admin)
  Future<Map<String, dynamic>> createDispatcher(Map<String, dynamic> payload) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/dispatchers',
        data: payload,
      );

      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        throw ApiException('Formato de respuesta inválido al crear dispatcher');
      }

      return data;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error al crear dispatcher: $e');
    }
  }

  /// PUT /dispatchers/:id (admin)
  Future<Dispatcher> updateDispatcher(String dispatcherId, Map<String, dynamic> payload) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError('Dispatcher ID es requerido');
    }

    try {
      final response = await _client.put<Map<String, dynamic>>(
        '/dispatchers/$dispatcherId',
        data: payload,
      );
      return _parseDispatcher(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error al actualizar dispatcher: $e');
    }
  }

  /// DELETE /dispatchers/:id (admin)
  Future<void> deleteDispatcher(String dispatcherId) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError('Dispatcher ID es requerido');
    }

    try {
      await _client.delete('/dispatchers/$dispatcherId');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error al eliminar dispatcher: $e');
    }
  }

  /// **************
  /// ** Parsers ***
  /// **************

  List<Dispatcher> _parseDispatcherList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! List) {
      throw ApiException('Formato de respuesta inválido para lista de dispatchers');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => Dispatcher.fromJson(json))
        .toList();
  }

  Dispatcher _parseDispatcher(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw ApiException('Formato de respuesta inválido para dispatcher');
    }

    return Dispatcher.fromJson(data);
  }
}
