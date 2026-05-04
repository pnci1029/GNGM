import '../offer.dart';

class OfferListResponseDto {
  final List<Offer> offers;

  const OfferListResponseDto({
    required this.offers,
  });

  factory OfferListResponseDto.fromJson(Map<String, dynamic> json) {
    return OfferListResponseDto(
      offers: (json['offers'] as List)
          .map((offer) => Offer.fromJson(offer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers.map((offer) => offer.toJson()).toList(),
    };
  }
}