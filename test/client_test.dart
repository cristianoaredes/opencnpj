import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:opencnpj/opencnpj.dart';
import 'package:test/test.dart';

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

    test('search throws InvalidCNPJException for non-14 digit CNPJ', () async {
      expect(
        () => openCnpj.search('123'),
        throwsA(isA<InvalidCNPJException>()),
      );
      expect(
        () => openCnpj.search('1234567890123456'),
        throwsA(isA<InvalidCNPJException>()),
      );
    });

    test('search throws NotFoundException on 404 response', () async {
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => openCnpj.search('00000000000000'),
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

    test('sanitizeCnpj removes non-numeric characters', () {
      final sanitized = OpenCNPJ.sanitizeCnpj('06.990.590/0001-23');
      expect(sanitized, '06990590000123');

      final sanitized2 = OpenCNPJ.sanitizeCnpj('123-abc-456');
      expect(sanitized2, '123456');
    });
  });
}
