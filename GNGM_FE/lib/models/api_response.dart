class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
  
  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
      message: null,
    );
  }
  
  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      data: null,
      message: message,
    );
  }
}