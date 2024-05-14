import 'dart:io';

import 'package:shelf/shelf_io.dart';
import 'package:shelf_plus/shelf_plus.dart';

import 'boostrap/service_register.dart';
import 'middlerware/auth_middlerware.dart';
import 'router/arcade_router.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  var router = Router().plus;

  registerServices();

  ArcadeRouter(router: router);

  var app = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addMiddleware(
        authMiddleware(),
      )
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(app, ip, port);
  print('Server IP: ${ip.address}');
  print('Server Port: $port');
}
