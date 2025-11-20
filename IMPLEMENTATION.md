# Implementation Plan - OpenCNPJ Dart Wrapper

## Journal
*   **Phase 1:** Project Initialization.
    *   **Actions:** Created the `opencnpj` directory, initialized git, created the package using `dart create`, removed boilerplate, updated `pubspec.yaml`, `README.md`, and `CHANGELOG.md`. Created initial folder structure `lib/src/models` and `lib/src/exceptions`. Ran `dart pub get`.
    *   **Learnings/Surprises:** `json_serializable` complained about SDK and `json_annotation` versions which were fixed by updating `pubspec.yaml`.
    *   **Deviations:** Had to manually fix `pubspec.yaml` due to version mismatches and re-run `dart pub get` and `build_runner`.
*   **Phase 2:** Models & JSON Serialization.
    *   **Actions:** Created `lib/src/models/company.dart` with `Company`, `Phone`, and `Partner` classes, including `json_serializable` annotations and `Equatable`. Ran `dart run build_runner build --delete-conflicting-outputs`. Created `test/models_test.dart` with a sample JSON fixture and verification. Ran `dart test`, `dart fix --apply`, and `dart format .`.
    *   **Learnings/Surprises:** None beyond the initial `pubspec.yaml` issues.
    *   **Deviations:** None.
*   **Phase 3:** Core Client Implementation.
    *   **Actions:** Created `lib/src/exceptions/exceptions.dart` with custom exceptions. Created `lib/src/client.dart` implementing `IOpenCNPJ` and the `search` method, including input sanitization, HTTP requests, status code checking, and JSON decoding. Made `sanitizeCnpj` a static method to facilitate testing. Exported main classes in `lib/opencnpj.dart`. Created unit tests in `test/client_test.dart` using `mocktail` to mock `http.Client`. Ran `dart fix --apply`, `dart format .`, and `dart test` (all passed).
    *   **Learnings/Surprises:** Realized `_sanitizeCnpj` as a private instance method was not directly testable; refactored it to a public static `sanitizeCnpj` method.
    *   **Deviations:** Refactored the `_sanitizeCnpj` method during testing for better testability.
*   **Phase 4:** Final Polish & Documentation.
    *   **Actions:** Created a working example in `example/main.dart`. Updated `README.md` with installation, usage, and supported fields. Created `GEMINI.md` with project context. Ran `dart analyze` (no issues), `dart test` (all passed), and verified `pubspec.yaml` metadata. Made final commit.
    *   **Learnings/Surprises:** None.
    *   **Deviations:** None.
*   **Next Phase: Validação e Formatação de CNPJ.**
    *   **Actions:** Adicionado `cpf_cnpj_validator` ao `pubspec.yaml`. Refatorado `lib/src/client.dart` para usar `CNPJValidator.strip` para sanitização e `CNPJValidator.isValid` para validação, e adicionado `OpenCNPJ.formatCnpj` usando `CNPJValidator.format`. Atualizado `test/client_test.dart` para refletir a nova validação e os testes de formatação. Executado `dart fix`, `dart format`, `dart test` (todos passaram).
    *   **Learnings/Surprises:** A implementação manual inicial de `isValid` estava incorreta, levando à decisão de usar uma biblioteca externa (`cpf_cnpj_validator`) para robustez. O pacote `cpf_cnpj_validator` introduziu dependências do Flutter e advertências de versão, mas os testes passaram após a integração.
    *   **Deviations:** Substituí a implementação manual de `isValid` e `sanitizeCnpj` pela biblioteca `cpf_cnpj_validator` para garantir a correção e reduzir a complexidade.
*   **Verificação Final para a Próxima Release.**
    *   **Actions:** Executado `dart analyze` (no issues), `dart test` (all passed). Atualizado `CHANGELOG.md` com as novas features. Atualizado `pubspec.yaml` para a versão `0.2.0`. Commitado a release `0.2.0`.
    *   **Learnings/Surprises:** N/A.
    *   **Deviations:** N/A.

## Phase 1: Project Setup
- [X] Create a pure Dart package using `dart create -t package .` (force to overwrite if needed, or handle manually if `dart create` complains about non-empty dir). *Note: Since we already `git init`ed, we might need to be careful. `dart create --force` might be needed or just manual setup.*
- [X] Remove default `lib/opencnpj.dart` and `example/opencnpj_example.dart` boilerplate if they don't match our structure.
- [X] Update `pubspec.yaml`:
    -   Name: `opencnpj`
    -   Description: "A Dart client library for the OpenCNPJ API."
    -   Version: `0.1.0`
    -   Dependencies: `http`, `json_annotation`, `equatable`.
    -   Dev Dependencies: `build_runner`, `json_serializable`, `mocktail`, `lints`, `test`.
- [X] Update `README.md` with a placeholder description.
- [X] Create `CHANGELOG.md` initialized at `0.1.0`.
- [X] Create basic folder structure: `lib/src/`, `lib/src/models/`, `lib/src/exceptions/`.
- [X] Run `dart pub get`.
- [X] Commit initial setup.

## Phase 2: Models & JSON Serialization
- [X] Create `lib/src/models/company.dart` with `json_serializable` annotations.
- [ ] Create `lib/src/models/activity.dart` (CNAE). *Correction: CNAEs are simple string lists in the JSON, so no dedicated model is needed.*
- [ ] Create `lib/src/models/partner.dart` (QSA). *Correction: Partner is already included in company.dart.*
- [ ] Create `lib/src/models/address.dart` (Extract address fields into a composed object or keep flat? *Decision: Keep flat in Company or separate if cleaner. Let's separate Address for cleaner API if the JSON structure permits, otherwise flat mapped.* -> *Refinement: JSON is flat. We will use flat mapping in `Company` or a custom `fromJson` if we really want a nested object. For simplicity and 1:1 mapping, we will keep it flat but maybe group getters.*)
    -   *Correction*: Let's map 1:1 to the API response for the DTOs to avoid complexity in serialization.
- [X] Run `dart run build_runner build --delete-conflicting-outputs` to generate `*.g.dart` files.
- [X] Create unit tests in `test/models_test.dart` to verify JSON decoding against a sample fixture.
- [X] Run `dart fix` e `dart format`.
- [X] Commit models.

## Phase 3: Core Client Implementation
- [X] Create `lib/src/exceptions/exceptions.dart` (`InvalidCNPJException`, `NotFoundException`, `OpenCNPJException`).
- [X] Create `lib/src/client.dart` implementing the `search` method.
    -   Implement input sanitization (regex to remove symbols).
    -   Implement HTTP GET request.
    -   Implement status code checking (200, 404, others).
    -   Implement JSON decoding and model mapping.
- [X] Export main classes in `lib/opencnpj.dart`.
- [X] Create unit tests in `test/client_test.dart` using `mocktail` to mock `http.Client`.
    -   Test success case.
    -   Test 404 case.
    -   Test invalid format case.
    -   Test server error case.
- [X] Run `dart fix` e `dart format`.
- [X] Commit client logic.

## Phase 4: Final Polish & Documentation
- [X] Create a working example in `example/main.dart` showing how to fetch a company.
- [X] Update `README.md` with:
    -   Installation instructions.
    -   Usage example.
    -   Supported fields summary.
- [X] Create `GEMINI.md` com o contexto do projeto.
- [X] Run `dart analyze` to ensure no lint errors.
- [X] Run all tests `dart test`.
- [X] Verify `pubspec.yaml` metadata.
- [X] Final commit.

## Próxima Fase: Validação e Formatação de CNPJ
- [X] Adicionar um método estático `bool isValid(String cnpj)` à classe `OpenCNPJ` (ou uma nova classe `CnpjUtils`).
    -   Este método deve sanitizar o CNPJ de entrada e então aplicar a lógica de validação de dígitos verificadores (DV1 e DV2).
    -   Retornar `true` se o CNPJ for válido, `false` caso contrário.
- [X] Integrar a validação no método `search` do `OpenCNPJ` (antes da chamada HTTP).
    -   Se `OpenCNPJ.isValid(sanitizedCnpj)` retornar `false`, lançar `InvalidCNPJException` com uma mensagem mais específica.
- [X] Criar/modificar unit tests em `test/client_test.dart` (ou um novo `test/cnpj_utils_test.dart`) para o método `isValid`.
    -   Testar CNPJs válidos e inválidos.
    -   Testar o comportamento do `search` com CNPJs válidos e inválidos localmente.
- [X] Adicionar um método estático `String formatCnpj(String cnpj)` à classe `OpenCNPJ` (ou `CnpjUtils`).
    -   Este método deve receber um CNPJ sanitizado (apenas números) de 14 dígitos.
    -   Aplicar a máscara `XX.XXX.XXX/XXXX-XX`.
    -   Lançar `FormatException` ou `ArgumentError` se o CNPJ de entrada não tiver 14 dígitos.
- [ ] (Opcional, mas útil) Adicionar um método getter `String get formattedCnpj` ao modelo `Company`.
    -   Internamente, ele chamaria `OpenCNPJ.formatCnpj(this.cnpj)`.
- [X] Criar/modificar unit tests em `test/client_test.dart` (ou `test/cnpj_utils_test.dart`) para o método `formatCnpj`.
    -   Testar a formatação de CNPJs válidos.
    -   Testar o lançamento de exceção para CNPJs com comprimento incorreto.
- [X] Atualizar o `example/main.dart` para demonstrar o uso da formatação.
- [X] Atualizar o `README.md` para incluir a nova funcionalidade de formatação.
- [X] Executar `dart fix` e `dart format`.
- [X] Commitar as alterações.

### Verificação Final para a Próxima Release:
- [X] Executar `dart analyze` para garantir que não há erros de lint.
- [X] Executar todos os testes `dart test`.
- [X] Atualizar `CHANGELOG.md` com as novas features.
- [X] Atualizar `pubspec.yaml` para a versão `0.2.0`.
- [ ] Commit final da release `0.2.0`.