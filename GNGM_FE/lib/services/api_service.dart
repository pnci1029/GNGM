import 'api_client_factory.dart';

class ApiService {
  final ApiClientInterface _apiClient;

  ApiService(this._apiClient);

  // 기본 HTTP 메서드들
  Future<dynamic> get<T>(String endpoint, {T Function(dynamic)? fromJson}) {
    return _apiClient.get<T>(endpoint, fromJson: fromJson);
  }

  Future<dynamic> post<T>(String endpoint, {dynamic data, T Function(dynamic)? fromJson}) {
    return _apiClient.post<T>(endpoint, data: data, fromJson: fromJson);
  }

  Future<dynamic> put<T>(String endpoint, {dynamic data, T Function(dynamic)? fromJson}) {
    return _apiClient.put<T>(endpoint, data: data, fromJson: fromJson);
  }

  Future<dynamic> delete<T>(String endpoint, {T Function(dynamic)? fromJson}) {
    return _apiClient.delete<T>(endpoint, fromJson: fromJson);
  }
}