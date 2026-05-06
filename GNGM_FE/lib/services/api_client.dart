import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../models/api_response.dart';
import 'api_client_factory.dart';

class ApiClient implements ApiClientInterface {
  late final Dio _dio;
  late final CookieJar _cookieJar;
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000/api/v1');
  
  ApiClient() {
    _cookieJar = CookieJar();
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
      // Enable credentials for cross-origin requests
      extra: {'withCredentials': true},
    ));
    
    // Add cookie manager to automatically handle cookies
    _dio.interceptors.add(CookieManager(_cookieJar));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 Request: ${options.method} ${options.path}');
          print('📨 Headers: ${options.headers}');
          print('🍪 Cookies: ${_cookieJar.loadForRequest(Uri.parse(baseUrl + options.path))}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response: ${response.statusCode}');
          if (response.headers['set-cookie'] != null) {
            print('🍪 Set-Cookie: ${response.headers['set-cookie']}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
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
  
  void clearCookies() {
    _cookieJar.deleteAll();
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
      // 백엔드 응답의 success 필드 확인
      final isSuccess = response.data?['success'] ?? true;
      
      if (isSuccess) {
        T? data;
        if (fromJson != null && response.data != null) {
          // 백엔드 응답이 { "success": true, "data": {...} } 형태인 경우 data 부분만 전달
          final responseData = response.data['data'] ?? response.data;
          data = fromJson(responseData);
        } else {
          data = response.data;
        }
        
        return ApiResponse<T>(
          success: true,
          data: data,
          message: response.data?['message'],
        );
      } else {
        return ApiResponse<T>(
          success: false,
          data: null,
          message: response.data?['message'] ?? '요청 처리에 실패했습니다.',
        );
      }
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