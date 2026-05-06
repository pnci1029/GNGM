import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_client_factory.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final ApiClientInterface _apiClient;

  User? _user;
  bool _isLoading = false;
  bool _isInitializing = true; // 앱 시작시 인증 상태 확인 중인지
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing; // 초기화 중인지 여부
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isLoggedIn => !_isInitializing && _user != null;

  AuthProvider(this._authService, this._apiClient) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // 웹과 모바일 모두 SharedPreferences 사용 (웹에서 쿠키가 제대로 작동하지 않음)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        _apiClient.setAuthToken(token);
        await getCurrentUser();
      }
    } catch (e) {
      // 초기화 실패시에도 앱이 계속 실행되도록
      print('🔥 Auth initialization failed: $e');
    } finally {
      // 스플래시 화면이 너무 빨리 사라지지 않도록 최소 1초 지연
      await Future.delayed(const Duration(milliseconds: 800));
      _isInitializing = false;
      notifyListeners();
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
        // 웹과 모바일 모두 토큰 저장 (accessToken 사용)
        final accessToken = response.data!.tokens.accessToken;
        await _saveToken(accessToken);
        _apiClient.setAuthToken(accessToken);
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
        // 웹과 모바일 모두 토큰 저장 (accessToken 사용)
        final accessToken = response.data!.tokens.accessToken;
        await _saveToken(accessToken);
        _apiClient.setAuthToken(accessToken);
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
      } else {
        _user = null; // 로그아웃하지 말고 사용자만 null로 설정
      }
    } catch (e) {
      _user = null; // 에러 발생시에도 사용자만 null로 설정
    }
    // notifyListeners는 finally에서 호출됨
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
    double? locationLat,
    double? locationLng,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.updateProfile(
        name: name,
        phone: phone,
        profileImage: profileImage,
        locationLat: locationLat,
        locationLng: locationLng,
      );

      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
        return true;
      }

      _setError(response.message ?? '프로필 업데이트에 실패했습니다.');
      return false;
    } catch (e) {
      _setError('프로필 업데이트 중 오류가 발생했습니다.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
    } catch (e) {
      // 로그아웃 요청 실패해도 로컬 상태는 클리어
    }

    // 웹과 모바일 모두 토큰 클리어
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
