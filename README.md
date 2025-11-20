# OpenCNPJ Dart Client

A Dart client library for the [OpenCNPJ API](https://opencnpj.org/).

## Disclaimer
This `opencnpj` package is an **unofficial** client library developed independently. It is not maintained by, endorsed by, or affiliated with the official [OpenCNPJ project](https://opencnpj.org/) or its original maintainers. It aims to provide a convenient Dart interface for the public OpenCNPJ API.

## About OpenCNPJ
[OpenCNPJ](https://opencnpj.org/) is a free and open-source initiative that provides public company registration data (Cadastro Nacional da Pessoa Jurídica - CNPJ) for Brazilian companies, sourced from the Receita Federal (Brazilian Federal Revenue). The project offers an API, downloadable datasets, and a public Google BigQuery dataset. For more details, visit the [official OpenCNPJ website](https://opencnpj.org/).

## Features

*   Fetch comprehensive company details by CNPJ.
*   **Local CNPJ validation** for format and mathematical integrity before API calls.
*   **CNPJ formatting** for display purposes (`XX.XXX.XXX/XXXX-XX`).
*   Strongly typed models for easy data access.
*   Robust error handling for API-specific and network issues.

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  opencnpj: ^0.2.0
```

Then run `dart pub get`.

### Usage

```dart
import 'package:opencnpj/opencnpj.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart'; // For direct validation

void main() async {
  final opencnpj = OpenCNPJ();

  // Replace with a valid CNPJ
  const cnpj = '06.990.590/0001-23'; // Example: GOOGLE BRASIL INTERNET LTDA.

  try {
    print('Searching for CNPJ: $cnpj');
    final company = await opencnpj.search(cnpj);
    print('Company Found: ${company.razaoSocial}');
    print('CNPJ (raw): ${company.cnpj}');
    print('CNPJ (formatted): ${OpenCNPJ.formatCnpj(company.cnpj)}');
    print('Status: ${company.situacaoCadastral}');
    // ... access other fields as needed

    if (company.email != null) {
      print('Email: ${company.email}');
    }
    if (company.telefones.isNotEmpty) {
      print('Phone: (${company.telefones.first.ddd}) ${company.telefones.first.numero}');
    }
    if (company.qsa.isNotEmpty) {
      print('Partners: ');
      for (final partner in company.qsa) {
        print('- ${partner.nomeSocio} (${partner.qualificacaoSocio})');
      }
    }

    // Example of direct local CNPJ validation using cpf_cnpj_validator
    final validCnpj = '12.175.094/0001-19';
    final invalidCnpj = '123';
    print('\nIs $validCnpj valid? ${CNPJValidator.isValid(validCnpj)}');
    print('Is $invalidCnpj valid? ${CNPJValidator.isValid(invalidCnpj)}');

  } on InvalidCNPJException catch (e) {
    print('Error: ${e.message}');
  } on NotFoundException catch (e) {
    print('Error: ${e.message}');
  } on OpenCNPJException catch (e) {
    print('Error: ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
```

## API Limitations & Data Source

*   **Rate Limit:** The official OpenCNPJ API has a rate limit of **50 requests per second per IP address**. Please respect this limit to avoid temporary blocks.
*   **Data Source:** All data is sourced from the Receita Federal (Brazilian Federal Revenue).
*   **Data Freshness:** The OpenCNPJ database is updated **monthly**. Therefore, information may not reflect real-time changes.
*   **Static API:** The API serves static data, which contributes to its high availability and speed but means that some CNPJs might not be found if they were registered after the last database update.

## Supported Fields

The `Company` model and its nested models (`Phone`, `Partner`) provide access to the following fields, directly mapping the JSON response from the OpenCNPJ API (which in turn reflects data from Receita Federal):

*   `cnpj` (String)
*   `razaoSocial` (String)
*   `nomeFantasia` (String?)
*   `situacaoCadastral` (String)
*   `dataSituacaoCadastral` (String)
*   `matrizFilial` (String)
*   `dataInicioAtividade` (String)
*   `cnaePrincipal` (String)
*   `cnaesSecundarios` (List<String>)
*   `naturezaJuridica` (String)
*   `logradouro` (String)
*   `numero` (String)
*   `complemento` (String?)
*   `bairro` (String)
*   `cep` (String)
*   `uf` (String)
*   `municipio` (String)
*   `email` (String?)
*   `telefones` (List<Phone>)
*   `capitalSocial` (String)
*   `porteEmpresa` (String)
*   `opcaoSimples` (String?)
*   `dataOpcaoSimples` (String?)
*   `opcaoMei` (String?)
*   `dataOpcaoMei` (String?)
*   `qsa` (List<Partner>)

### Phone Model
*   `ddd` (String)
*   `numero` (String)
*   `isFax` (bool)

### Partner Model
*   `nomeSocio` (String)
*   `cnpjCpfSocio` (String)
*   `qualificacaoSocio` (String)
*   `dataEntradaSociedade` (String)
*   `identificadorSocio` (String)
*   `faixaEtaria` (String)
