import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart' as db;
import 'package:shared/shared.dart';
import 'package:stormberry/stormberry.dart';


FutureOr<Response> onRequest(RequestContext context, String id) {
  if (context.request.method == HttpMethod.get) {
    return _get(context, id);
  }
  return Response.json(body: 'Not Found');
}

Future<Response> _get(RequestContext context, String id) async {
  final database = context.read<Database>();
  
  final user = await database.users.queryUser(int.parse(id));
  if (user == null) {
    return Response.json(body: 'Not Found', statusCode: HttpStatus.notFound);
  } else {
    final sharedUser = User.fromDb(user);
    return Response.json(body: sharedUser.toJson());
  }
}
