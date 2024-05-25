import 'package:shelf/shelf.dart';

import '../boostrap/service_register.dart';
import '../service/auth_service.dart';

Middleware authMiddleware() => (Handler innerHandler) {
      List<Map> publicRoutes = [
        {'path': 'login', 'method': 'POST'},
        {'path': 'user', 'method': 'POST'},
        {'path': 'event', 'method': 'GET'},
        {'path': 'event_multi', 'method': 'GET'},
      ];

      return (Request request) async {
        for (var route in publicRoutes) {
          if (request.url.path == route['path'] && request.method == route['method']) {
            return innerHandler(request);
          }
        }

        final authorization = request.headers['Authorization'];

        if (authorization == null || !service<AuthService>().isTokenValid(authorization)) {
          return Response.forbidden('Você não tem permissão para acessar este recurso.');
        }

        final response = await innerHandler(request);

        return response;
      };
    };
