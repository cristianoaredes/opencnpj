import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opencnpj/src/exceptions/exceptions.dart';
import 'package:opencnpj/src/models/company.dart';

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
    final sanitizedCnpj = OpenCNPJ.sanitizeCnpj(cnpj);
    if (sanitizedCnpj.length != 14) {
      throw const InvalidCNPJException(
        'CNPJ must contain exactly 14 digits after sanitization.',
      );
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
      throw OpenCNPJException('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static String sanitizeCnpj(String cnpj) {
    return cnpj.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
