import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:packlead/core/models/order.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }
}

class OrdersApiClient {
  OrdersApiClient({http.Client? httpClient, String? baseUrl})
      : _httpClient = httpClient ?? http.Client(),
        baseUrl = baseUrl ?? dotenv.env['ORDERS_API_BASE_URL'] ?? _defaultBaseUrl {
    log('OrdersApiClient baseUrl=$baseUrl', name: 'OrdersApiClient');
  }

  static const String _defaultBaseUrl =
      'https://q0eo9qj8ka.execute-api.us-east-1.amazonaws.com';

  final http.Client _httpClient;
  final String baseUrl;

  Future<List<Order>> getOrders({
    String? state,
    String? dispatcherId,
    String? zone,
    int? limit,
  }) async {
    final filters = <String, String?>{
      'state': state,
      'dispatcherId': dispatcherId,
      'zone': zone,
    };

    final providedFilters =
        filters.entries.where((entry) => entry.value != null).toList();

    if (providedFilters.length != 1) {
      throw ArgumentError('Exactly one of state, dispatcherId, or zone must be provided.');
    }

    final queryParameters = <String, String>{
      providedFilters.first.key: providedFilters.first.value!,
      if (limit != null) 'limit': '$limit',
    };

    final uri = _buildUri('/orders', queryParameters: queryParameters);
    _logRequest('GET', uri);
    final response = await _httpClient.get(uri);
    _logResponse('GET', uri, response);

    if (response.statusCode != 200) {
      throw _buildException(response, 'Failed to load orders');
    }

    return _parseOrderList(response.body);
  }

  Future<Order> getOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }

    final uri = _buildUri('/orders/$orderId');
    _logRequest('GET', uri);
    final response = await _httpClient.get(uri);
    _logResponse('GET', uri, response);

    if (response.statusCode != 200) {
      throw _buildException(response, 'Failed to load order');
    }

    return _parseOrder(response.body);
  }

  Future<Order> createOrder(Map<String, dynamic> payload) async {
    final uri = _buildUri('/orders');
    _logRequest('POST', uri, body: payload);
    final response = await _httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    _logResponse('POST', uri, response);

    if (response.statusCode != 201) {
      throw _buildException(response, 'Failed to create order');
    }

    return _parseOrder(response.body);
  }

  Future<Order> updateOrder(String orderId, Map<String, dynamic> payload) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }

    if (payload.isEmpty) {
      throw ArgumentError('Update payload cannot be empty');
    }

    final uri = _buildUri('/orders/$orderId');
    _logRequest('PUT', uri, body: payload);
    final response = await _httpClient.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    _logResponse('PUT', uri, response);

    if (response.statusCode != 200) {
      throw _buildException(response, 'Failed to update order');
    }

    return _parseOrder(response.body);
  }

  Future<void> deleteOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }

    final uri = _buildUri('/orders/$orderId');
    _logRequest('DELETE', uri);
    final response = await _httpClient.delete(uri);
    _logResponse('DELETE', uri, response);

    if (response.statusCode != 200) {
      throw _buildException(response, 'Failed to delete order');
    }
  }

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$normalizedBase$normalizedPath').replace(
      queryParameters: queryParameters,
    );
  }

  List<Order> _parseOrderList(String responseBody) {
    final decoded = _decode(responseBody);
    final data = decoded['data'];

    if (data is! List) {
      throw ApiException('Unexpected response format for orders list');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((orderJson) => Order.fromJson(orderJson))
        .toList();
  }

  Order _parseOrder(String responseBody) {
    final decoded = _decode(responseBody);
    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      throw ApiException('Unexpected response format for order');
    }

    return Order.fromJson(data);
  }

  Map<String, dynamic> _decode(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Fall through to error below.
    }

    throw ApiException('Unable to decode server response');
  }

  void _logRequest(String method, Uri uri, {Object? body}) {
    log(
      '$method $uri${body != null ? ' body=${jsonEncode(body)}' : ''}',
      name: 'OrdersApiClient',
    );
  }

  void _logResponse(String method, Uri uri, http.Response response) {
    log(
      '$method $uri status=${response.statusCode} body=${response.body}',
      name: 'OrdersApiClient',
    );
  }

  ApiException _buildException(http.Response response, String fallbackMessage) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return ApiException(
          decoded['message'] as String,
          statusCode: response.statusCode,
        );
      }
    } catch (_) {
      // Ignore JSON parsing errors for error messages.
    }

    return ApiException(fallbackMessage, statusCode: response.statusCode);
  }
}
