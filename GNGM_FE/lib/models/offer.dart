import 'user.dart';

class Offer {
  final String id;
  final String requestId;
  final String providerId;
  final String? message;
  final int? offeredFee;
  final String status;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User provider;

  const Offer({
    required this.id,
    required this.requestId,
    required this.providerId,
    this.message,
    this.offeredFee,
    required this.status,
    this.acceptedAt,
    this.rejectedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.provider,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      requestId: json['requestId'],
      providerId: json['providerId'],
      message: json['message'],
      offeredFee: json['offeredFee'],
      status: json['status'],
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      provider: User.fromJson(json['provider']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'providerId': providerId,
      'message': message,
      'offeredFee': offeredFee,
      'status': status,
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'provider': provider.toJson(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';
}