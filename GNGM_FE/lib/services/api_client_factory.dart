import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'web_api_client.dart';

abstract class ApiClientInterface {
  Future<dynamic> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  });
  
  Future<dynamic> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  });
  
  Future<dynamic> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  });
  
  Future<dynamic> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  });
  
  void setAuthToken(String token);
  void clearAuthToken();
  void clearCookies();
}

class ApiClientFactory {
  static ApiClientInterface create() {
    if (kIsWeb) {
      return WebApiClient();
    } else {
      return ApiClient();
    }
  }
}