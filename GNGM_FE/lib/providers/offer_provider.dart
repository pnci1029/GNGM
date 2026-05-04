import 'package:flutter/foundation.dart';
import '../models/offer.dart';
import '../services/offer_service.dart';

class OfferProvider with ChangeNotifier {
  final OfferService _offerService;

  List<Offer> _offers = [];
  List<Offer> _myOffers = [];
  bool _isLoading = false;
  String? _error;

  List<Offer> get offers => _offers;
  List<Offer> get myOffers => _myOffers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  OfferProvider(this._offerService);

  Future<void> loadOffersForRequest(String requestId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _offerService.getOffersForRequest(requestId);

      if (response.success && response.data != null) {
        _offers = response.data!.offers;
        notifyListeners();
      } else {
        _setError(response.message ?? '제안 목록을 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('제안 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createOffer({
    required String requestId,
    String? message,
    int? offeredFee,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _offerService.createOffer(
        requestId: requestId,
        message: message,
        offeredFee: offeredFee,
      );

      if (response.success && response.data != null) {
        _offers.insert(0, response.data!);
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? '제안 생성에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('제안 생성 중 오류가 발생했습니다.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptOffer({
    required String requestId,
    required String offerId,
  }) async {
    try {
      final response = await _offerService.acceptOffer(
        requestId: requestId,
        offerId: offerId,
      );

      if (response.success && response.data != null) {
        final updatedOffer = response.data!;
        final index = _offers.indexWhere((offer) => offer.id == offerId);
        if (index != -1) {
          _offers[index] = updatedOffer;
          notifyListeners();
        }
        return true;
      } else {
        _setError(response.message ?? '제안 승인에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('제안 승인 중 오류가 발생했습니다.');
      return false;
    }
  }

  Future<bool> rejectOffer({
    required String requestId,
    required String offerId,
  }) async {
    try {
      final response = await _offerService.rejectOffer(
        requestId: requestId,
        offerId: offerId,
      );

      if (response.success && response.data != null) {
        final updatedOffer = response.data!;
        final index = _offers.indexWhere((offer) => offer.id == offerId);
        if (index != -1) {
          _offers[index] = updatedOffer;
          notifyListeners();
        }
        return true;
      } else {
        _setError(response.message ?? '제안 거절에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('제안 거절 중 오류가 발생했습니다.');
      return false;
    }
  }

  Future<void> loadMyOffers() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _offerService.getMyOffers();

      if (response.success && response.data != null) {
        _myOffers = response.data!.offers;
        notifyListeners();
      } else {
        _setError(response.message ?? '내 제안 목록을 불러올 수 없습니다.');
      }
    } catch (e) {
      _setError('내 제안 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  void clearOffers() {
    _offers.clear();
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