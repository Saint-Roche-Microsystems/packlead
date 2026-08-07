import 'package:packlead/core/constants/strings/errors.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/utils/app_logger.dart';
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
    } catch (e, st) {
      AppLogger.error(DispatchersApiErrors.getDispatchers, error: e, stackTrace: st);
      throw ApiException(DispatchersApiErrors.getDispatchers);
    }
  }

  /// GET /dispatchers/:id (admin)
  Future<Dispatcher> getDispatcher(String dispatcherId) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError(DispatchersApiErrors.dispatcherIdRequired);
    }

    try {
      final response = await _client.get<Map<String, dynamic>>('/dispatchers/$dispatcherId');
      return _parseDispatcher(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(DispatchersApiErrors.getDispatcher, error: e, stackTrace: st);
      throw ApiException(DispatchersApiErrors.getDispatcher);
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
        throw ApiException(DispatchersApiErrors.invalidCreateDispatcherResponse);
      }

      return data;
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(DispatchersApiErrors.createDispatcher, error: e, stackTrace: st);
      throw ApiException(DispatchersApiErrors.createDispatcher);
    }
  }

  /// PUT /dispatchers/:id (admin)
  Future<Dispatcher> updateDispatcher(String dispatcherId, Map<String, dynamic> payload) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError(DispatchersApiErrors.dispatcherIdRequired);
    }

    try {
      final response = await _client.put<Map<String, dynamic>>(
        '/dispatchers/$dispatcherId',
        data: payload,
      );
      return _parseDispatcher(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(DispatchersApiErrors.updateDispatcher, error: e, stackTrace: st);
      throw ApiException(DispatchersApiErrors.updateDispatcher);
    }
  }

  /// DELETE /dispatchers/:id (admin)
  Future<void> deleteDispatcher(String dispatcherId) async {
    if (dispatcherId.isEmpty) {
      throw ArgumentError(DispatchersApiErrors.dispatcherIdRequired);
    }

    try {
      await _client.delete('/dispatchers/$dispatcherId');
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(DispatchersApiErrors.deleteDispatcher, error: e, stackTrace: st);
      throw ApiException(DispatchersApiErrors.deleteDispatcher);
    }
  }

  /// **************
  /// ** Parsers ***
  /// **************

  List<Dispatcher> _parseDispatcherList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! List) {
      throw ApiException(DispatchersApiErrors.invalidDispatcherListResponse);
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => Dispatcher.fromJson(json))
        .toList();
  }

  Dispatcher _parseDispatcher(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw ApiException(DispatchersApiErrors.invalidDispatcherResponse);
    }

    return Dispatcher.fromJson(data);
  }
}
