class UpdateRequestStatusDto {
  final String status;

  const UpdateRequestStatusDto({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}