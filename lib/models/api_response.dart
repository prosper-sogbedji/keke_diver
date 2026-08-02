class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, {T Function(dynamic)? fromJsonT}) {
    return ApiResponse(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'] as T?,
    );
  }

  bool get isSuccess => status == 'success';
}
