class ErrorType {
  final String message;
  final String value;
  final String trackingCode;

  ErrorType({
    required this.message,
    required this.value,
    required this.trackingCode,
  });

  factory ErrorType.fromJson(Map<String, dynamic> json) => ErrorType(
        message: json['message'],
        value: json['value'],
        trackingCode: json['trackingCode'],
      );

  static List<Map<String, dynamic>> list(Map<String, dynamic> json) {
    List<Map<String, ErrorType>> errors = [];

    json.forEach((key, value) {
      final typeError = ErrorType.fromJson(value);

      final mapError = {
        key: typeError,
      };

      errors.add(mapError);
    });

    return errors;
  }

  @override
  String toString() {
    return '''
    ErrorType(
      message: $message,
      value: $value,
      trackingCode: $trackingCode,
    )
    ''';
  }
}
