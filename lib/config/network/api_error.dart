class ApiError {
  final String message;
  final dynamic value;
  final String trackingCode;

  ApiError({
    required this.message,
    required this.value,
    required this.trackingCode,
  });

  @override
  String toString() {
    return '''
    ApiError(
      message: $message,
      value: $value,
      trackingCode: $trackingCode,
    )
    ''';
  }
}