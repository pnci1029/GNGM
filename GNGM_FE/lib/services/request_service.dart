import '../models/api_response.dart';
import '../models/request.dart';
import '../models/dto/create_request_dto.dart';
import '../models/dto/request_list_response_dto.dart';
import '../models/dto/update_request_status_dto.dart';
import 'api_client.dart';

class RequestService {
  final ApiClient _apiClient;
  
  RequestService(this._apiClient);
  
  Future<ApiResponse<RequestListResponseDto>> getRequests({
    String? categoryType,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categoryType != null && categoryType != 'all') {
      queryParams['categoryType'] = categoryType;
    }
    
    final response = await _apiClient.get<RequestListResponseDto>(
      '/requests',
      queryParameters: queryParams,
      fromJson: (data) => RequestListResponseDto.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<RequestListResponseDto>> getNearbyRequests({
    required double lat,
    required double lng,
    double radius = 5.0,
  }) async {
    final response = await _apiClient.get<RequestListResponseDto>(
      '/requests/nearby',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
      },
      fromJson: (data) => RequestListResponseDto.fromJson(data),
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
    final requestDto = CreateRequestDto(
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
    
    final response = await _apiClient.post<Request>(
      '/requests',
      data: requestDto.toJson(),
      fromJson: (data) => Request.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<RequestListResponseDto>> getMyRequests() async {
    final response = await _apiClient.get<RequestListResponseDto>(
      '/requests/my',
      fromJson: (data) => RequestListResponseDto.fromJson(data),
    );
    
    return response;
  }
  
  Future<ApiResponse<Request>> updateRequestStatus(
    String id, 
    String status,
  ) async {
    final statusDto = UpdateRequestStatusDto(status: status);
    
    final response = await _apiClient.put<Request>(
      '/requests/$id/status',
      data: statusDto.toJson(),
      fromJson: (data) => Request.fromJson(data),
    );
    
    return response;
  }
}