class Request {
  final String id;
  final String userId;
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
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Request({
    required this.id,
    required this.userId,
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
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      categoryType: json['categoryType'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      pickupLat: (json['pickupLat'] ?? 0.0).toDouble(),
      pickupLng: (json['pickupLng'] ?? 0.0).toDouble(),
      deliveryAddress: json['deliveryAddress'],
      deliveryLat: json['deliveryLat']?.toDouble(),
      deliveryLng: json['deliveryLng']?.toDouble(),
      feeAmount: json['feeAmount'] ?? 0,
      status: json['status'] ?? 'open',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'categoryType': categoryType,
      'title': title,
      'description': description,
      'pickupAddress': pickupAddress,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'deliveryAddress': deliveryAddress,
      'deliveryLat': deliveryLat,
      'deliveryLng': deliveryLng,
      'feeAmount': feeAmount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Request copyWith({
    String? id,
    String? userId,
    String? categoryType,
    String? title,
    String? description,
    String? pickupAddress,
    double? pickupLat,
    double? pickupLng,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    int? feeAmount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryType: categoryType ?? this.categoryType,
      title: title ?? this.title,
      description: description ?? this.description,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLat: deliveryLat ?? this.deliveryLat,
      deliveryLng: deliveryLng ?? this.deliveryLng,
      feeAmount: feeAmount ?? this.feeAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get categoryDisplayName {
    switch (categoryType) {
      case 'shopping':
        return '쇼핑';
      case 'delivery':
        return '배송';
      case 'transport':
        return '동행';
      case 'companion':
        return '기타';
      default:
        return categoryType;
    }
  }

  String get formattedFee {
    return '${feeAmount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}원';
  }
}