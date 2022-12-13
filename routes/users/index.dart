import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart' as db;
import 'package:shared/shared.dart';
import 'package:stormberry/internals.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getAll(context);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getAll(RequestContext context) async {
  final database = context.read<Database>();
  final users = await database.users.queryUsers();
  final sharedUsers = users.map(User.fromDb).toList();
  return Response.json(
    body: {'users': sharedUsers},
    headers: {'Content-Type': 'Applaction/json'},
  );
}
