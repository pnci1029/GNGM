import '../models/api_response.dart';
import '../models/offer.dart';
import '../models/dto/create_offer_dto.dart';
import '../models/dto/offer_list_response_dto.dart';
import 'api_client.dart';

class OfferService {
  final ApiClient _apiClient;

  OfferService(this._apiClient);

  Future<ApiResponse<Offer>> createOffer({
    required String requestId,
    String? message,
    int? offeredFee,
  }) async {
    final offerDto = CreateOfferDto(
      requestId: requestId,
      message: message,
      offeredFee: offeredFee,
    );

    final response = await _apiClient.post<Offer>(
      '/offers',
      data: offerDto.toJson(),
      fromJson: (data) => Offer.fromJson(data['offer']),
    );

    return response;
  }

  Future<ApiResponse<OfferListResponseDto>> getOffersForRequest(String requestId) async {
    final response = await _apiClient.get<OfferListResponseDto>(
      '/offers/request/$requestId',
      fromJson: (data) => OfferListResponseDto.fromJson(data),
    );

    return response;
  }

  Future<ApiResponse<Offer>> acceptOffer({
    required String requestId,
    required String offerId,
  }) async {
    final response = await _apiClient.post<Offer>(
      '/offers/request/$requestId/$offerId/accept',
      fromJson: (data) => Offer.fromJson(data['offer']),
    );

    return response;
  }

  Future<ApiResponse<Offer>> rejectOffer({
    required String requestId,
    required String offerId,
  }) async {
    final response = await _apiClient.post<Offer>(
      '/offers/request/$requestId/$offerId/reject',
      fromJson: (data) => Offer.fromJson(data['offer']),
    );

    return response;
  }

  Future<ApiResponse<OfferListResponseDto>> getMyOffers() async {
    final response = await _apiClient.get<OfferListResponseDto>(
      '/offers/my',
      fromJson: (data) => OfferListResponseDto.fromJson(data),
    );

    return response;
  }
}