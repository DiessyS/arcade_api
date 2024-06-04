import 'package:shelf/shelf.dart';

import '../boostrap/service_register.dart';
import '../service/auth_service.dart';

Middleware authMiddleware() => (Handler innerHandler) {
      List<Map> publicRoutes = [
        {'path': RegExp('ping'), 'method': 'GET'},
        {'path': RegExp('login'), 'method': 'POST'},
        {'path': RegExp('user'), 'method': 'POST'},
        {'path': RegExp('event'), 'method': 'GET'},
        {'path': RegExp('event/type/(w+)\$'), 'method': 'GET'},
      ];

      return (Request request) async {
        for (var route in publicRoutes) {
          if (route['path'].hasMatch(request.url.path) && request.method == route['method']) {
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
