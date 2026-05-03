import 'package:flutter/foundation.dart';
import '../models/request.dart';
import '../services/request_service.dart';

class RequestProvider with ChangeNotifier {
  final RequestService _requestService;
  
  List<Request> _requests = [];
  List<Request> _myRequests = [];
  Request? _selectedRequest;
  bool _isLoading = false;
  String? _error;
  
  List<Request> get requests => _requests;
  List<Request> get myRequests => _myRequests;
  Request? get selectedRequest => _selectedRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  RequestProvider(this._requestService);
  
  Future<void> loadRequests({String? categoryType}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _requestService.getRequests(
        categoryType: categoryType,
      );
      
      if (response.success && response.data != null) {
        _requests = response.data!;
        notifyListeners();
      } else {
        _setError(response.message ?? '요청 목록을 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('요청 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> loadNearbyRequests({
    required double lat,
    required double lng,
    double radius = 5.0,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _requestService.getNearbyRequests(
        lat: lat,
        lng: lng,
        radius: radius,
      );
      
      if (response.success && response.data != null) {
        _requests = response.data!;
        notifyListeners();
      } else {
        _setError(response.message ?? '주변 요청을 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('주변 요청을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> loadRequestById(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _requestService.getRequestById(id);
      
      if (response.success && response.data != null) {
        _selectedRequest = response.data;
        notifyListeners();
      } else {
        _setError(response.message ?? '요청 상세 정보를 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('요청 상세 정보를 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> createRequest({
    required String categoryType,
    required String title,
    required String description,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    required int feeAmount,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _requestService.createRequest(
        categoryType: categoryType,
        title: title,
        description: description,
        pickupAddress: pickupAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        deliveryAddress: deliveryAddress,
        deliveryLat: deliveryLat,
        deliveryLng: deliveryLng,
        feeAmount: feeAmount,
      );
      
      if (response.success && response.data != null) {
        _requests.insert(0, response.data!);
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? '요청 생성에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('요청 생성 중 오류가 발생했습니다.');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> loadMyRequests() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _requestService.getMyRequests();
      
      if (response.success && response.data != null) {
        _myRequests = response.data!;
        notifyListeners();
      } else {
        _setError(response.message ?? '내 요청 목록을 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('내 요청 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateRequestStatus(String id, String status) async {
    try {
      final response = await _requestService.updateRequestStatus(id, status);
      
      if (response.success && response.data != null) {
        final updatedRequest = response.data!;
        
        final requestIndex = _requests.indexWhere((r) => r.id == id);
        if (requestIndex != -1) {
          _requests[requestIndex] = updatedRequest;
        }
        
        final myRequestIndex = _myRequests.indexWhere((r) => r.id == id);
        if (myRequestIndex != -1) {
          _myRequests[myRequestIndex] = updatedRequest;
        }
        
        if (_selectedRequest?.id == id) {
          _selectedRequest = updatedRequest;
        }
        
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? '요청 상태 업데이트에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('요청 상태 업데이트 중 오류가 발생했습니다.');
      return false;
    }
  }
  
  void clearSelectedRequest() {
    _selectedRequest = null;
    notifyListeners();
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