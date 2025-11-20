// lib/src/exceptions/exceptions.dart
class InvalidCNPJException implements Exception {
  final String message;
  const InvalidCNPJException([this.message = 'CNPJ format is invalid.']);

  @override
  String toString() => 'InvalidCNPJException: $message';
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([
    this.message = 'Company not found for the given CNPJ.',
  ]);

  @override
  String toString() => 'NotFoundException: $message';
}

class OpenCNPJException implements Exception {
  final String message;
  final int? statusCode;
  const OpenCNPJException([
    this.message = 'An unknown error occurred.',
    this.statusCode,
  ]);

  @override
  String toString() =>
      'OpenCNPJException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}
