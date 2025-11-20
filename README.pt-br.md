![OpenCNPJ Banner](banner.jpeg)

# OpenCNPJ Dart Client

[![Pub Version](https://img.shields.io/pub/v/opencnpj?logo=dart)](https://pub.dev/packages/opencnpj)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/SDK-Dart%203.0%2B-blue?logo=dart)](https://dart.dev)
[![Style: Effective Dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

Uma biblioteca cliente Dart **não oficial**, robusta e pura para a [API OpenCNPJ](https://opencnpj.org/).
Consulte, valide e formate dados de empresas brasileiras (CNPJ) facilmente em suas aplicações Dart e Flutter.

[🇺🇸 Read in English](README.md)

---

## 📋 Índice

-   [Funcionalidades](#-funcionalidades)
-   [Instalação](#-instalação)
-   [Uso](#-uso)
    -   [Consulta Básica](#consulta-básica)
    -   [Validação](#validação)
    -   [Formatação](#formatação)
-   [Campos Suportados](#-campos-suportados)
-   [Limitações da API e Fonte de Dados](#-limitações-da-api-e-fonte-de-dados)
-   [Contribuindo](#-contribuindo)
-   [Aviso Legal](#-aviso-legal)
-   [Licença](#-licença)

---

## ✨ Funcionalidades

*   🚀 **Fácil de Usar:** API simples e assíncrona para buscar detalhes de empresas.
*   🛡️ **Validação Robusta:** Valide o formato e os dígitos verificadores do CNPJ localmente *antes* de chamar a API.
*   🎨 **Formatação:** Utilitários integrados para formatar CNPJs (`XX.XXX.XXX/XXXX-XX`).
*   📦 **Tipagem Forte:** Suporte completo para todos os campos do OpenCNPJ, incluindo Sócios (`QSA`) e CNAEs.
*   ⚡ **Desempenho:** Zero dependência do Flutter (roda no servidor, CLI e web).
*   🔒 **Segurança:** Sanitização de entrada e exceções específicas para tratamento de erros previsível.

---

## 📦 Instalação

Adicione isso ao seu `pubspec.yaml`:

```yaml
dependencies:
  opencnpj: ^0.2.0
```

Ou execute:

```bash
dart pub add opencnpj
```

---

## 💻 Uso

### Consulta Básica

Importe o pacote e instancie o cliente. Você pode buscar dados da empresa usando uma string de CNPJ formatada ou não.

```dart
import 'package:opencnpj/opencnpj.dart';

void main() async {
  final client = OpenCNPJ();

  try {
    // Buscar dados da empresa
    final company = await client.search('06.990.590/0001-23');

    print('🏢 Empresa: ${company.razaoSocial}');
    print('📍 Estado: ${company.uf}');
    print('💼 Situação: ${company.situacaoCadastral}');
    
    // Acessar dados aninhados (Sócios/QSA)
    if (company.qsa.isNotEmpty) {
      print('👥 Sócios:');
      for (final partner in company.qsa) {
        print('   - ${partner.nomeSocio} (${partner.qualificacaoSocio})');
      }
    }
  } on NotFoundException {
    print('❌ Empresa não encontrada.');
  } on InvalidCNPJException {
    print('❌ Formato de CNPJ inválido.');
  } catch (e) {
    print('❌ Erro: $e');
  }
}
```

### Validação

Valide um CNPJ localmente para evitar chamadas desnecessárias à API. Usa validação matemática estrita (dígitos verificadores).

```dart
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

bool isValid = CNPJValidator.isValid('06.990.590/0001-23'); // true
bool isInvalid = CNPJValidator.isValid('11.111.111/1111-11'); // false
```

### Formatação

Formate uma string de CNPJ bruta para exibição na sua interface.

```dart
import 'package:opencnpj/opencnpj.dart';

String formatted = OpenCNPJ.formatCnpj('06990590000123');
print(formatted); // 06.990.590/0001-23
```

---

## 📊 Campos Suportados

O modelo `Company` mapeia 1:1 com a resposta do OpenCNPJ. Os campos principais incluem:

| Campo | Descrição |
| :--- | :--- |
| `cnpj` | O ID da empresa de 14 dígitos. |
| `razaoSocial` | Nome legal/Razão Social. |
| `nomeFantasia` | Nome fantasia (opcional). |
| `situacaoCadastral` | Situação cadastral (ex: ATIVA). |
| `cnaePrincipal` | Código da atividade econômica principal. |
| `qsa` | Lista de sócios (Quadro de Sócios e Administradores). |
| `telefones` | Lista de números de contato. |
| `address` | Campos como `logradouro`, `bairro`, `municipio`, `uf`. |

---

## ⚠️ Limitações da API e Fonte de Dados

*   **Limite de Taxa (Rate Limit):** A API oficial permite **50 requisições por segundo por IP**.
*   **Fonte de Dados:** Receita Federal do Brasil.
*   **Frequência de Atualização:** Mensal. Os dados podem não refletir mudanças em tempo real (ex: uma empresa aberta ontem).
*   **Offline/Estático:** A API serve arquivos estáticos; se um CNPJ não estiver no dump mensal, retornará 404.

---

## 🤝 Contribuindo

Contribuições são bem-vindas!
1.  Faça um Fork deste repositório.
2.  Crie sua branch de feature (`git checkout -b feature/minha-feature`).
3.  Commite suas mudanças (`git commit -m 'Adiciona uma feature incrível'`).
4.  Faça o Push para a branch (`git push origin feature/minha-feature`).
5.  Abra um Pull Request.

---

## ⚖️ Aviso Legal

Esta biblioteca é um projeto open-source **não oficial** e não é afiliada à equipe do OpenCNPJ.org.
Para a documentação oficial da API, visite [opencnpj.org](https://opencnpj.org).

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
