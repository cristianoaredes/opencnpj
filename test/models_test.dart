import 'dart:convert';
import 'package:opencnpj/src/models/company.dart';
import 'package:test/test.dart';

void main() {
  group('Company Model', () {
    test('fromJson creates a valid Company object from JSON', () {
      final jsonString = """
        {
          "cnpj": "06990590000123",
          "razao_social": "GOOGLE BRASIL INTERNET LTDA.",
          "nome_fantasia": null,
          "situacao_cadastral": "ATIVA",
          "data_situacao_cadastral": "2005-07-26",
          "matriz_filial": "MATRIZ",
          "data_inicio_atividade": "2005-07-26",
          "cnae_principal": "6319400",
          "cnaes_secundarios": [
            "6311900",
            "7311400",
            "7319004",
            "7490104",
            "8230001",
            "8599604"
          ],
          "natureza_juridica": "SOCIEDADE EMPRESARIA LIMITADA",
          "logradouro": "AV BRIG FARIA LIMA",
          "numero": "3477",
          "complemento": null,
          "bairro": "ITAIM BIBI",
          "cep": "04538133",
          "uf": "SP",
          "municipio": "SAO PAULO",
          "email": null,
          "telefones": [
            {
              "ddd": "11",
              "numero": "37971000",
              "is_fax": false
            }
          ],
          "capital_social": "1.000.000,00",
          "porte_empresa": "DEMAIS",
          "opcao_simples": null,
          "data_opcao_simples": null,
          "opcao_mei": null,
          "data_opcao_mei": null,
          "qsa": [
            {
              "nome_socio": "DENIS CALVAER",
              "cnpj_cpf_socio": "***376368**",
              "qualificacao_socio": "ADMINISTRADOR",
              "data_entrada_sociedade": "2020-03-02",
              "identificador_socio": "PESSOA FISICA",
              "faixa_etaria": "41 a 50 anos"
            },
            {
              "nome_socio": "GOOGLE LLC",
              "cnpj_cpf_socio": "00000000000000",
              "qualificacao_socio": "SOCIO PESSOA JURIDICA DOMICILIADO NO EXTERIOR",
              "data_entrada_sociedade": "2005-07-26",
              "identificador_socio": "PESSOA JURIDICA",
              "faixa_etaria": "NAO SE APLICA"
            }
          ]
        }
      """;
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final company = Company.fromJson(jsonMap);

      expect(company.cnpj, "06990590000123");
      expect(company.razaoSocial, "GOOGLE BRASIL INTERNET LTDA.");
      expect(company.situacaoCadastral, "ATIVA");
      expect(company.telefones.length, 1);
      expect(company.telefones[0].ddd, "11");
      expect(company.telefones[0].numero, "37971000");
      expect(company.telefones[0].isFax, false);
      expect(company.qsa.length, 2);
      expect(company.qsa[0].nomeSocio, "DENIS CALVAER");
    });
  });
}
