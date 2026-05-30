class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiException({
    required this.message,
    this.errors,
    this.statusCode,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.values.join('\n');
    }
    return message;
  }
}
