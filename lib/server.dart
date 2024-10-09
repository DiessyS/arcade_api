import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'boostrap/service_register.dart';
import 'middleware/auth_middleware.dart';
import 'router/arcade_router.dart';

void main(List<String> args) async {
  final InternetAddress ip = InternetAddress.anyIPv4;
  final RouterPlus router = Router().plus;

  registerServices();
  ArcadeRouter(router: router);

  final app = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addMiddleware(authMiddleware())
      .addHandler(router.call);

  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  await serve(app, ip, port);

  print('Server IP: ${ip.address}');
  print('Server Port: $port');
}
