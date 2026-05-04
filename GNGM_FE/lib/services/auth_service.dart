import '../models/api_response.dart';
import '../models/user.dart';
import '../models/dto/login_request_dto.dart';
import '../models/dto/register_request_dto.dart';
import '../models/dto/auth_response_dto.dart';
import 'api_client_factory.dart';

class AuthService {
  final ApiClientInterface _apiClient;
  
  AuthService(this._apiClient);
  
  Future<ApiResponse<AuthResponseDto>> login({
    required String email,
    required String password,
  }) async {
    final requestDto = LoginRequestDto(email: email, password: password);
    
    final response = await _apiClient.post<AuthResponseDto>(
      '/auth/login',
      data: requestDto.toJson(),
      fromJson: (data) => AuthResponseDto.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<AuthResponseDto>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final requestDto = RegisterRequestDto(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
    
    final response = await _apiClient.post<AuthResponseDto>(
      '/auth/register',
      data: requestDto.toJson(),
      fromJson: (data) => AuthResponseDto.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<User>> getCurrentUser() async {
    final response = await _apiClient.get<User>(
      '/auth/me',
      fromJson: (data) => User.fromJson(data['data']['user']),
    );
    
    return response;
  }
  
  Future<ApiResponse<void>> logout() async {
    final response = await _apiClient.post<void>('/auth/logout');
    return response;
  }

  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
    double? locationLat,
    double? locationLng,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (locationLat != null) data['locationLat'] = locationLat;
    if (locationLng != null) data['locationLng'] = locationLng;

    final response = await _apiClient.put<User>(
      '/auth/profile',
      data: data,
      fromJson: (data) => User.fromJson(data['data']['user']),
    );
    
    return response;
  }
}