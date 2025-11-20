# OpenCNPJ

A Dart client library for the [OpenCNPJ API](https://opencnpj.org/).

## Features

*   Fetch company details by CNPJ.
*   Strongly typed models.
*   Error handling for common API states.

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  opencnpj: ^0.1.0
```

Then run `dart pub get`.

### Usage

```dart
import 'package:opencnpj/opencnpj.dart';

void main() async {
  final opencnpj = OpenCNPJ();

  // Replace with a valid CNPJ
  const cnpj = '06.990.590/0001-23'; // Example: GOOGLE BRASIL INTERNET LTDA.

  try {
    print('Searching for CNPJ: $cnpj');
    final company = await opencnpj.search(cnpj);
    print('Company Found: ${company.razaoSocial}');
    print('CNPJ: ${company.cnpj}');
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

## Supported Fields

The `Company` model and its nested models (`Phone`, `Partner`) provide access to the following fields from the OpenCNPJ API:

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
