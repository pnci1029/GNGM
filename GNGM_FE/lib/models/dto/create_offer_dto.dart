class CreateOfferDto {
  final String requestId;
  final String? message;
  final int? offeredFee;

  const CreateOfferDto({
    required this.requestId,
    this.message,
    this.offeredFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'message': message,
      'offeredFee': offeredFee,
    };
  }
}