import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final ApiClient _apiClient;
  
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  
  AuthProvider(this._authService, this._apiClient) {
    _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      _apiClient.setAuthToken(token);
      await getCurrentUser();
    }
  }
  
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      
      if (response.success && response.data != null) {
        await _saveToken(response.data!.token);
        _apiClient.setAuthToken(response.data!.token);
        _user = response.data!.user;
        notifyListeners();
        return true;
      }
      
      _setError(response.message ?? '로그인에 실패했습니다.');
      return false;
    } catch (e) {
      _setError('로그인 중 오류가 발생했습니다.');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      
      if (response.success && response.data != null) {
        await _saveToken(response.data!.token);
        _apiClient.setAuthToken(response.data!.token);
        _user = response.data!.user;
        notifyListeners();
        return true;
      }
      
      _setError(response.message ?? '회원가입에 실패했습니다.');
      return false;
    } catch (e) {
      _setError('회원가입 중 오류가 발생했습니다.');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getCurrentUser() async {
    try {
      final response = await _authService.getCurrentUser();
      
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
      } else {
        await logout();
      }
    } catch (e) {
      await logout();
    }
  }
  
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
    } catch (e) {
      // 로그아웃 요청 실패해도 로컬 상태는 클리어
    }
    
    await _clearToken();
    _apiClient.clearAuthToken();
    _user = null;
    _clearError();
    _setLoading(false);
    notifyListeners();
  }
  
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}