![OpenCNPJ Banner](assets/banner.jpeg)

# OpenCNPJ Dart Client

[![Pub Version](https://img.shields.io/pub/v/opencnpj?logo=dart)](https://pub.dev/packages/opencnpj)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/SDK-Dart%203.0%2B-blue?logo=dart)](https://dart.dev)
[![Style: Effective Dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

An **unofficial**, robust, and pure Dart client library for the [OpenCNPJ API](https://opencnpj.org/).
Easily query, validate, and format Brazilian company data (CNPJ) in your Dart and Flutter applications.

[🇧🇷 Leia em Português](README.pt-br.md)

---

## 📋 Table of Contents

-   [Features](#-features)
-   [Installation](#-installation)
-   [Usage](#-usage)
    -   [Basic Query](#basic-query)
    -   [Validation](#validation)
    -   [Formatting](#formatting)
-   [Examples](#-examples)
-   [Supported Fields](#-supported-fields)
-   [API Limitations](#-api-limitations--data-source)
-   [Author](#-author)
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

## 📱 Examples

This repository includes fully functional examples to help you get started:

### Flutter Web Example

A responsive, mobile-first web application that auto-fills company registration forms using CNPJ search.

-   **Source:** `example/flutter_example`
-   **Run:**
    ```bash
    cd example/flutter_example
    flutter run -d chrome
    ```
-   **Demo:** [Watch the demo video](assets/exemplo_cnpj.mov)

### Shelf Server Example

A backend REST API built with Dart Shelf that proxies requests to OpenCNPJ and implements a CRUD for widgets.

-   **Source:** `example/server`
-   **Run:**
    ```bash
    cd example/server
    dart run bin/server.dart
    ```

---
-   [API Limitations](#-api-limitations--data-source)
-   [Author](#-author)
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
*   **Offline/Static:** The API serves static files; if a CNPJ isn\'t in the monthly dump, it returns 404.

---

## 👨‍💻 Author

**Cristiano Arêdes Costa**
Senior Software Engineer specializing in Flutter, Dart, and mobile development with 15+ years of experience.

- 🌐 Portfolio: [aredes.me](https://aredes.me)
- 💼 LinkedIn: [linkedin.com/in/cristianoaredes](https://www.linkedin.com/in/cristianoaredes)
- 📧 Email: cristianoaredes@icloud.com

### Other Open Source Projects

Check out my other open-source contributions:

- **[MCP DadosBR](https://github.com/crisaredes/mcp-dadosbr)** - Model Context Protocol server for Brazilian public data (CNPJ/CEP validation, Tavily search) with 62+ tools
- **[MCP Câmara](https://github.com/crisaredes/mcp-camara)** - MCP server for Brazilian Chamber of Deputies legislative data with 62+ tools for bills, deputies, and votes
- **[Super-App Flutter Sample](https://github.com/crisaredes/super-app-flutter)** - Modular Flutter architecture example with GoRouter, GetIt, and BLoC pattern
- **[MCP Mobile Server](https://github.com/crisaredes/mcp-mobile)** - Android/iOS/Flutter build automation and CI/CD tooling via MCP
- **[AnythingToLLMs.txt](https://github.com/crisaredes/anything-to-llms)** - Universal document converter for LLM processing

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
