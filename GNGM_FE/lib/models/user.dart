class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final String providerType;
  final double? ratingAvg;
  final int trustScore;
  final double? locationLat;
  final double? locationLng;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.providerType,
    this.ratingAvg,
    this.trustScore = 0,
    this.locationLat,
    this.locationLng,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      providerType: json['providerType'] ?? 'local',
      ratingAvg: json['ratingAvg']?.toDouble(),
      trustScore: json['trustScore'] ?? 0,
      locationLat: json['locationLat']?.toDouble(),
      locationLng: json['locationLng']?.toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'providerType': providerType,
      'ratingAvg': ratingAvg,
      'trustScore': trustScore,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    String? providerType,
    double? ratingAvg,
    int? trustScore,
    double? locationLat,
    double? locationLng,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      providerType: providerType ?? this.providerType,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      trustScore: trustScore ?? this.trustScore,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasCompleteProfile {
    return locationLat != null && locationLng != null && name.isNotEmpty;
  }
}