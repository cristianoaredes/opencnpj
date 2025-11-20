import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opencnpj/src/exceptions/exceptions.dart';
import 'package:opencnpj/src/models/company.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart'; // New import

abstract class IOpenCNPJ {
  Future<Company> search(String cnpj);
}

class OpenCNPJ implements IOpenCNPJ {
  final http.Client _httpClient;
  final String _baseUrl;

  OpenCNPJ({
    http.Client? httpClient,
    String baseUrl = 'https://api.opencnpj.org',
  }) : _httpClient = httpClient ?? http.Client(),
       _baseUrl = baseUrl;

  @override
  Future<Company> search(String cnpj) async {
    final sanitizedCnpj = CNPJValidator.strip(
      cnpj,
    ); // Use validator for sanitization
    if (!CNPJValidator.isValid(sanitizedCnpj)) {
      // Use validator for validation
      throw const InvalidCNPJException('CNPJ provided is invalid.');
    }

    final uri = Uri.parse('$_baseUrl/$sanitizedCnpj');

    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Company.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
        throw const NotFoundException('Company not found for the given CNPJ.');
      } else {
        throw OpenCNPJException(
          'Failed to fetch company data.',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      // Check for specific media type error
      if (e.message.contains('Invalid media type')) {
        throw OpenCNPJException(
          'API Response Error: The server returned an invalid Content-Type header. This is a known issue with some Flutter Web environments. Details: ${e.message}',
        );
      }
      throw OpenCNPJException('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static String formatCnpj(String cnpj) {
    if (!CNPJValidator.isValid(cnpj)) {
      throw FormatException('Cannot format an invalid CNPJ.');
    }
    return CNPJValidator.format(cnpj);
  }
}
