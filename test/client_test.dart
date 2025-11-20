import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:opencnpj/opencnpj.dart';
import 'package:test/test.dart';
// New import for tests

class MockClient extends Mock implements http.Client {}

void main() {
  group('OpenCNPJ', () {
    late OpenCNPJ openCnpj;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      openCnpj = OpenCNPJ(httpClient: mockClient);
      registerFallbackValue(Uri.parse('https://api.opencnpj.org'));
    });

    test('search returns Company on successful 200 response', () async {
      final jsonResponse = {
        "cnpj": "06990590000123",
        "razao_social": "GOOGLE BRASIL INTERNET LTDA.",
        "situacao_cadastral": "ATIVA",
        "data_situacao_cadastral": "2005-07-26",
        "matriz_filial": "MATRIZ",
        "data_inicio_atividade": "2005-07-26",
        "cnae_principal": "6319400",
        "cnaes_secundarios": [],
        "natureza_juridica": "SOCIEDADE EMPRESARIA LIMITADA",
        "logradouro": "AV BRIG FARIA LIMA",
        "numero": "3477",
        "bairro": "ITAIM BIBI",
        "cep": "04538133",
        "uf": "SP",
        "municipio": "SAO PAULO",
        "telefones": [],
        "capital_social": "1.000.000,00",
        "porte_empresa": "DEMAIS",
        "qsa": [],
      };

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response(json.encode(jsonResponse), 200));

      final company = await openCnpj.search('06.990.590/0001-23');
      expect(company, isA<Company>());
      expect(company.cnpj, '06990590000123');
      expect(company.razaoSocial, 'GOOGLE BRASIL INTERNET LTDA.');
    });

    test('search handles null lists gracefully', () async {
      final jsonResponse = {
        "cnpj": "06990590000123",
        "razao_social": "GOOGLE BRASIL INTERNET LTDA.",
        "situacao_cadastral": "ATIVA",
        "data_situacao_cadastral": "2005-07-26",
        "matriz_filial": "MATRIZ",
        "data_inicio_atividade": "2005-07-26",
        "cnae_principal": "6319400",
        "cnaes_secundarios": null,
        "natureza_juridica": "SOCIEDADE EMPRESARIA LIMITADA",
        "logradouro": "AV BRIG FARIA LIMA",
        "numero": "3477",
        "bairro": "ITAIM BIBI",
        "cep": "04538133",
        "uf": "SP",
        "municipio": "SAO PAULO",
        "telefones": null,
        "capital_social": "1.000.000,00",
        "porte_empresa": "DEMAIS",
        "qsa": null,
      };

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response(json.encode(jsonResponse), 200));

      final company = await openCnpj.search('06.990.590/0001-23');
      expect(company.cnaesSecundarios, isEmpty);
      expect(company.telefones, isEmpty);
      expect(company.qsa, isEmpty);
    });

    test('search throws InvalidCNPJException for invalid CNPJ', () async {
      // Using an invalid CNPJ that CNPJValidator would fail
      expect(
        () => openCnpj.search('12345678000199'),
        throwsA(isA<InvalidCNPJException>()),
      );
    });

    test('formatCnpj returns a formatted CNPJ for valid input', () {
      final unformattedCnpj = '12175094000119';
      final formattedCnpj = OpenCNPJ.formatCnpj(unformattedCnpj);
      expect(formattedCnpj, '12.175.094/0001-19');
    });

    test('formatCnpj throws FormatException for invalid CNPJ', () {
      expect(() => OpenCNPJ.formatCnpj('123'), throwsA(isA<FormatException>()));
      expect(
        () => OpenCNPJ.formatCnpj('12345678000199'), // Invalid digits
        throwsA(isA<FormatException>()),
      );
    });

    test('search throws NotFoundException on 404 response', () async {
      when(
        () => mockClient.get(
          Uri.parse('https://api.opencnpj.org/12175094000119'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => openCnpj.search('12.175.094/0001-19'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('search throws OpenCNPJException on other error responses', () async {
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      expect(
        () => openCnpj.search('06990590000123'),
        throwsA(isA<OpenCNPJException>()),
      );
    });

    test('search throws OpenCNPJException on network error', () async {
      when(
        () => mockClient.get(any()),
      ).thenThrow(http.ClientException('No internet'));

      expect(
        () => openCnpj.search('06990590000123'),
        throwsA(isA<OpenCNPJException>()),
      );
    });
  });
}
