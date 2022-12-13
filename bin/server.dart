// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/users/index.dart' as users_index;
import '../routes/users/[id].dart' as users_$id;
import '../routes/posts/index.dart' as posts_index;
import '../routes/posts/[name].dart' as posts_$name;

import '../routes/users/_middleware.dart' as users_middleware;
import '../routes/posts/_middleware.dart' as posts_middleware;

void main() => createServer();

Future<HttpServer> createServer() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, ip, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/posts', (context) => buildPostsHandler()(context))
    ..mount('/users', (context) => buildUsersHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildPostsHandler() {
  final pipeline = const Pipeline().addMiddleware(posts_middleware.middleware);
  final router = Router()
    ..all('/', (context) => posts_index.onRequest(context,))..all('/<name>', (context,name,) => posts_$name.onRequest(context,name,));
  return pipeline.addHandler(router);
}

Handler buildUsersHandler() {
  final pipeline = const Pipeline().addMiddleware(users_middleware.middleware);
  final router = Router()
    ..all('/', (context) => users_index.onRequest(context,))..all('/<id>', (context,id,) => users_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}
