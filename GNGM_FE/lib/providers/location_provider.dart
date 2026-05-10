import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../services/address_service.dart';
import '../services/web_location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  bool _hasPermission = false;
  String _currentAddress = '위치 정보 없음';
  final AddressService _addressService = AddressService();
  final WebLocationService _webLocationService = WebLocationService();

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPermission => _hasPermission;
  String get currentAddress => _currentAddress;

  double get latitude => _currentPosition?.latitude ?? 37.498;
  double get longitude => _currentPosition?.longitude ?? 127.0276;

  LocationProvider() {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _checkPermissions();
    if (_hasPermission) {
      await getCurrentLocation();
    }
  }

  Future<void> _checkPermissions() async {
    try {
      // 웹 환경에서는 더 간단하게 권한 체크
      if (kIsWeb) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            _setError('위치 권한이 필요합니다. 브라우저에서 위치 접근을 허용해 주세요.');
            return;
          }
        }
        
        if (permission == LocationPermission.deniedForever) {
          _setError('위치 권한이 거부되었습니다. 브라우저 설정에서 위치 접근을 허용해 주세요.');
          return;
        }
        
        _hasPermission = true;
        _clearError();
        return;
      }

      // 모바일 환경에서의 기존 로직
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('위치 서비스가 비활성화되어 있습니다.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('위치 권한이 거부되었습니다.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해 주세요.');
        return;
      }

      _hasPermission = true;
      _clearError();
    } catch (e) {
      _setError('위치 권한 확인 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    
    _setLoading(true);
    _clearError();

    try {
      if (kIsWeb) {
        
        // 웹 환경에서는 HTML5 geolocation API 직접 사용
        if (!_webLocationService.isLocationSupported()) {
          _setError('브라우저에서 위치 서비스를 지원하지 않습니다.');
          _hasPermission = false;
          return;
        }
        
        final locationData = await _webLocationService.getCurrentPosition();
        
        if (locationData != null) {
          final lat = locationData['latitude']!;
          final lng = locationData['longitude']!;
          
          // Position 객체 생성 (웹용)
          _currentPosition = Position(
            latitude: lat,
            longitude: lng,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
          
          _hasPermission = true;
          await _updateAddress(lat, lng);
          _clearError();
        } else {
          _setError('위치 정보를 가져올 수 없습니다. 브라우저에서 위치 접근을 허용해 주세요.');
          _hasPermission = false;
        }
      } else {
        // 모바일 환경에서는 기존 로직 유지
        if (!_hasPermission) {
          await _checkPermissions();
          if (!_hasPermission) return;
        }

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        
        _currentPosition = position;
        await _updateAddress(position.latitude, position.longitude);
        _clearError();
      }
    } catch (e, stackTrace) {
      if (kIsWeb) {
        _setError('브라우저에서 위치 접근을 허용해 주세요. 주소창 왼쪽의 위치 아이콘을 클릭해보세요.');
      } else {
        _setError('위치를 가져올 수 없습니다: $e');
      }
      _hasPermission = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshLocation() async {
    await getCurrentLocation();
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

  double calculateDistance(double lat, double lng) {
    if (_currentPosition == null) return double.infinity;
    
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lng,
    ) / 1000; // Convert to kilometers
  }

  Future<void> _updateAddress(double lat, double lng) async {
    try {
      final address = await _addressService.getAddressFromCoordinates(lat, lng);
      _currentAddress = address;
      notifyListeners();
    } catch (e) {
      _currentAddress = '주소 변환 실패';
      notifyListeners();
    }
  }
}