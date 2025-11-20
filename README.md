# OpenCNPJ Dart Client

[![Pub Version](https://img.shields.io/pub/v/opencnpj?logo=dart)](https://pub.dev/packages/opencnpj)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/SDK-Dart%203.0%2B-blue?logo=dart)](https://dart.dev)
[![Style: Effective Dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

An **unofficial**, robust, and pure Dart client library for the [OpenCNPJ API](https://opencnpj.org/).
Easily query, validate, and format Brazilian company data (CNPJ) in your Dart and Flutter applications.

---

## 📋 Table of Contents

-   [Features](#-features)
-   [Installation](#-installation)
-   [Usage](#-usage)
    -   [Basic Query](#basic-query)
    -   [Validation](#validation)
    -   [Formatting](#formatting)
-   [Supported Fields](#-supported-fields)
-   [API Limitations](#-api-limitations--data-source)
-   [Contributing](#-contributing)
-   [Disclaimer](#-disclaimer)
-   [License](#-license)

---

## ✨ Features

*   🚀 **Easy to Use:** Simple, async API to fetch company details.
*   🛡️ **Robust Validation:** Validate CNPJ format and check digits locally *before* hitting the API.
*   🎨 **Formatting:** Built-in utilities to format CNPJs (`XX.XXX.XXX/XXXX-XX`).
*   📦 **Strongly Typed:** Full support for all OpenCNPJ fields, including Partners (`QSA`) and CNAEs.
*   ⚡ **Performance:** Zero-dependency on Flutter (runs on server, CLI, and web).
*   🔒 **Safety:** Input sanitization and specific exceptions for predictable error handling.

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  opencnpj: ^0.2.0
```

Or run:

```bash
dart pub add opencnpj
```

---

## 💻 Usage

### Basic Query

Import the package and instantiate the client. You can fetch company data using a formatted or unformatted CNPJ string.

```dart
import 'package:opencnpj/opencnpj.dart';

void main() async {
  final client = OpenCNPJ();

  try {
    // Fetch company data
    final company = await client.search('06.990.590/0001-23');

    print('🏢 Company: ${company.razaoSocial}');
    print('📍 State: ${company.uf}');
    print('💼 Status: ${company.situacaoCadastral}');
    
    // Access nested data (Partners/QSA)
    if (company.qsa.isNotEmpty) {
      print('👥 Partners:');
      for (final partner in company.qsa) {
        print('   - ${partner.nomeSocio} (${partner.qualificacaoSocio})');
      }
    }
  } on NotFoundException {
    print('❌ Company not found.');
  } on InvalidCNPJException {
    print('❌ Invalid CNPJ format.');
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

### Validation

Validate a CNPJ locally to avoid unnecessary API calls. Uses strict mathematical validation (check digits).

```dart
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

bool isValid = CNPJValidator.isValid('06.990.590/0001-23'); // true
bool isInvalid = CNPJValidator.isValid('11.111.111/1111-11'); // false
```

### Formatting

Format a raw CNPJ string for display in your UI.

```dart
import 'package:opencnpj/opencnpj.dart';

String formatted = OpenCNPJ.formatCnpj('06990590000123');
print(formatted); // 06.990.590/0001-23
```

---

## 📊 Supported Fields

The `Company` model maps 1:1 with the OpenCNPJ response. Key fields include:

| Field | Description |
| :--- | :--- |
| `cnpj` | The 14-digit company ID. |
| `razaoSocial` | Legal name. |
| `nomeFantasia` | Trade name (optional). |
| `situacaoCadastral` | Registration status (e.g., ATIVA). |
| `cnaePrincipal` | Main economic activity code. |
| `qsa` | List of partners (Quadra de Sócios). |
| `telefones` | List of contact numbers. |
| `address` | Fields like `logradouro`, `bairro`, `municipio`, `uf`. |

---

## ⚠️ API Limitations & Data Source

*   **Rate Limit:** The official API allows **50 requests per second per IP**.
*   **Data Source:** Receita Federal (Brazilian Federal Revenue).
*   **Update Frequency:** Monthly. Data may not reflect real-time changes (e.g., a company opened yesterday).
*   **Offline/Static:** The API serves static files; if a CNPJ isn't in the monthly dump, it returns 404.

---

## 🤝 Contributing

Contributions are welcome!
1.  Fork this repository.
2.  Create your feature branch (`git checkout -b feature/amazing-feature`).
3.  Commit your changes (`git commit -m 'Add some amazing feature'`).
4.  Push to the branch (`git push origin feature/amazing-feature`).
5.  Open a Pull Request.

---

## ⚖️ Disclaimer

This library is an **unofficial** open-source project and is not affiliated with the OpenCNPJ.org team.
For official API documentation, visit [opencnpj.org](https://opencnpj.org).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.