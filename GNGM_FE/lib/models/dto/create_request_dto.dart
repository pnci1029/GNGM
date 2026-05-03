class CreateRequestDto {
  final String categoryType;
  final String title;
  final String description;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final int feeAmount;

  const CreateRequestDto({
    required this.categoryType,
    required this.title,
    required this.description,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    required this.feeAmount,
  });

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}