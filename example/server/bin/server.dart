import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:opencnpj_server_example/widget_model.dart';
import 'package:opencnpj/opencnpj.dart';

// In-memory store
final _widgets = <String, WidgetModel>{};
final _openCnpj = OpenCNPJ();

void main() async {
  print('Starting server...');
  final router = Router();

  // Create
  router.post('/widgets', (Request request) async {
    try {
      final payload = await request.readAsString();
      final json = jsonDecode(payload);
      final widget = WidgetModel.fromJson(json);

      if (_widgets.containsKey(widget.id)) {
        return Response(409, body: 'Widget with ID ${widget.id} already exists');
      }

      _widgets[widget.id] = widget;
      return Response(201, body: jsonEncode(widget.toJson()), headers: {
        'content-type': 'application/json',
      });
    } catch (e) {
      return Response(400, body: 'Invalid request: $e');
    }
  });

  // Read All
  router.get('/widgets', (Request request) {
    final widgetList = _widgets.values.map((w) => w.toJson()).toList();
    return Response.ok(jsonEncode(widgetList), headers: {
      'content-type': 'application/json',
    });
  });

  // Read One
  router.get('/widgets/<id>', (Request request, String id) {
    final widget = _widgets[id];
    if (widget == null) {
      return Response.notFound('Widget not found');
    }
    return Response.ok(jsonEncode(widget.toJson()), headers: {
      'content-type': 'application/json',
    });
  });

  // Update
  router.put('/widgets/<id>', (Request request, String id) async {
    if (!_widgets.containsKey(id)) {
      return Response.notFound('Widget not found');
    }

    try {
      final payload = await request.readAsString();
      final json = jsonDecode(payload);
      // Ensure ID matches the URL path
      if (json['id'] != id) {
         return Response(400, body: 'ID mismatch between URL and body');
      }
      
      final widget = WidgetModel.fromJson(json);
      _widgets[id] = widget;
      
      return Response.ok(jsonEncode(widget.toJson()), headers: {
        'content-type': 'application/json',
      });
    } catch (e) {
      return Response(400, body: 'Invalid request: $e');
    }
  });

  // Delete
  router.delete('/widgets/<id>', (Request request, String id) {
    if (!_widgets.containsKey(id)) {
      return Response.notFound('Widget not found');
    }
    _widgets.remove(id);
    return Response.ok('Widget deleted');
  });

  // OpenCNPJ Proxy Endpoint
  router.get('/companies/<cnpj>', (Request request, String cnpj) async {
    try {
      final company = await _openCnpj.search(cnpj);
      return Response.ok(jsonEncode(company.toJson()), headers: {
        'content-type': 'application/json',
      });
    } on InvalidCNPJException catch (e) {
      return Response(400, body: 'Invalid CNPJ: ${e.message}');
    } on NotFoundException catch (e) {
      return Response.notFound('Company not found: ${e.message}');
    } catch (e) {
      return Response.internalServerError(body: 'Error fetching company: $e');
    }
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8081);
  print('Serving at http://${server.address.host}:${server.port}');
}
