# OpenCNPJ Server Example

This example demonstrates how to build a simple REST API using `shelf` and `opencnpj`.

## Features

-   **Widget CRUD**: A complete CRUD (Create, Read, Update, Delete) API for a "Widget" resource, using in-memory persistence.
-   **OpenCNPJ Proxy**: An endpoint that proxies requests to the OpenCNPJ API using the `opencnpj` library.

## Getting Started

1.  Navigate to the server directory:
    ```bash
    cd example/server
    ```

2.  Get dependencies:
    ```bash
    dart pub get
    ```

3.  Run the server:
    ```bash
    dart run bin/server.dart
    ```

The server will start at `http://localhost:8081`.

## API Endpoints

### Widgets

-   **POST /widgets**: Create a new widget.
    ```json
    {
      "id": "1",
      "name": "Widget 1",
      "description": "Description",
      "price": 10.0
    }
    ```
-   **GET /widgets**: List all widgets.
-   **GET /widgets/<id>**: Get a widget by ID.
-   **PUT /widgets/<id>**: Update a widget.
-   **DELETE /widgets/<id>**: Delete a widget.

### Companies

-   **GET /companies/<cnpj>**: Fetch company data by CNPJ.
    -   Example: `http://localhost:8081/companies/06990590000123`
