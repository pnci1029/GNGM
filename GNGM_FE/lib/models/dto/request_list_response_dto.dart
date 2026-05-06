import '../request.dart';

class RequestListResponseDto {
  final List<Request> requests;

  const RequestListResponseDto({
    required this.requests,
  });

  factory RequestListResponseDto.fromJson(Map<String, dynamic> json) {
    final requestsData = json['requests'] as List<dynamic>? ?? [];
    return RequestListResponseDto(
      requests: requestsData.map((item) => Request.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  List<dynamic> toJson() {
    return requests.map((request) => request.toJson()).toList();
  }
}