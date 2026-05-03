import '../models/api_response.dart';
import '../models/request.dart';
import 'api_client.dart';

class RequestService {
  final ApiClient _apiClient;
  
  RequestService(this._apiClient);
  
  Future<ApiResponse<List<Request>>> getRequests({
    String? categoryType,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categoryType != null && categoryType != 'all') {
      queryParams['categoryType'] = categoryType;
    }
    
    final response = await _apiClient.get<List<Request>>(
      '/requests',
      queryParameters: queryParams,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => Request.fromJson(item)).toList();
        }
        return <Request>[];
      },
    );
    
    return response;
  }
  
  Future<ApiResponse<List<Request>>> getNearbyRequests({
    required double lat,
    required double lng,
    double radius = 5.0,
  }) async {
    final response = await _apiClient.get<List<Request>>(
      '/requests/nearby',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
      },
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => Request.fromJson(item)).toList();
        }
        return <Request>[];
      },
    );
    
    return response;
  }
  
  Future<ApiResponse<Request>> getRequestById(String id) async {
    final response = await _apiClient.get<Request>(
      '/requests/$id',
      fromJson: (data) => Request.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<Request>> createRequest({
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
    final response = await _apiClient.post<Request>(
      '/requests',
      data: {
        'categoryType': categoryType,
        'title': title,
        'description': description,
        'pickupAddress': pickupAddress,
        'pickupLat': pickupLat,
        'pickupLng': pickupLng,
        if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
        if (deliveryLat != null) 'deliveryLat': deliveryLat,
        if (deliveryLng != null) 'deliveryLng': deliveryLng,
        'feeAmount': feeAmount,
      },
      fromJson: (data) => Request.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<List<Request>>> getMyRequests() async {
    final response = await _apiClient.get<List<Request>>(
      '/requests/my',
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => Request.fromJson(item)).toList();
        }
        return <Request>[];
      },
    );
    
    return response;
  }
  
  Future<ApiResponse<Request>> updateRequestStatus(
    String id, 
    String status,
  ) async {
    final response = await _apiClient.put<Request>(
      '/requests/$id/status',
      data: {'status': status},
      fromJson: (data) => Request.fromJson(data),
    );
    
    return response;
  }
}