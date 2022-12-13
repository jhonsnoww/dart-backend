import 'dart:async';

import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String name) async {
  return Response.json(body: {'name:': name});
}
