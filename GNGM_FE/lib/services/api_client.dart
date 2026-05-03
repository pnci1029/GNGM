import 'package:dio/dio.dart';
import '../models/api_response.dart';

class ApiClient {
  late final Dio _dio;
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
  
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(path);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      T? data;
      if (fromJson != null && response.data != null) {
        data = fromJson(response.data);
      } else {
        data = response.data;
      }
      
      return ApiResponse<T>(
        success: true,
        data: data,
        message: null,
      );
    } else {
      return ApiResponse<T>(
        success: false,
        data: null,
        message: response.data?['message'] ?? '알 수 없는 오류가 발생했습니다.',
      );
    }
  }
  
  ApiResponse<T> _handleError<T>(dynamic error) {
    String message = '네트워크 오류가 발생했습니다.';
    
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message = '연결 시간이 초과되었습니다.';
          break;
        case DioExceptionType.receiveTimeout:
          message = '응답 시간이 초과되었습니다.';
          break;
        case DioExceptionType.badResponse:
          message = error.response?.data?['message'] ?? '서버 오류가 발생했습니다.';
          break;
        case DioExceptionType.cancel:
          message = '요청이 취소되었습니다.';
          break;
        default:
          message = '네트워크 연결을 확인해 주세요.';
      }
    }
    
    return ApiResponse<T>(
      success: false,
      data: null,
      message: message,
    );
  }
}