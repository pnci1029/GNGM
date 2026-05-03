import '../request.dart';

class RequestListResponseDto {
  final List<Request> requests;

  const RequestListResponseDto({
    required this.requests,
  });

  factory RequestListResponseDto.fromJson(List<dynamic> json) {
    return RequestListResponseDto(
      requests: json.map((item) => Request.fromJson(item)).toList(),
    );
  }

  List<dynamic> toJson() {
    return requests.map((request) => request.toJson()).toList();
  }
}