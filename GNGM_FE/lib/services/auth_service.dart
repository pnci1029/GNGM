import '../models/api_response.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  
  AuthService(this._apiClient);
  
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (data) => data is Map<String, dynamic> ? data : {},
    );
    
    return response;
  }
  
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
        if (phone != null) 'phone': phone,
      },
      fromJson: (data) => data is Map<String, dynamic> ? data : {},
    );
    
    return response;
  }
  
  Future<ApiResponse<User>> getCurrentUser() async {
    final response = await _apiClient.get<User>(
      '/auth/me',
      fromJson: (data) => User.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<void>> logout() async {
    final response = await _apiClient.post<void>('/auth/logout');
    return response;
  }
}