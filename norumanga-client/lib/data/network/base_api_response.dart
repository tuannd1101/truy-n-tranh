class BaseApiResponse<T> {
  final String timestamp;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  BaseApiResponse({
    required this.timestamp,
    required this.message,
    this.data,
    this.errors,
  });

  factory BaseApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return BaseApiResponse(
      timestamp: json['timestamp'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  String getErrorMessage() {
    if (errors != null && errors!.isNotEmpty) {
      // Nối tất cả các message lỗi lại với nhau (đối với validation error)
      return errors!.values.join('\n');
    }
    return message;
  }
}
