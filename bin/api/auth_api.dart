import 'package:shelf_plus/shelf_plus.dart';

import '../service/auth_service.dart';

class AuthAPI {
  RouterPlus router;

  AuthAPI({required this.router}) {
    router.post('/login', _login);
  }

  Future<Response> _login(Request request) async {
    final parameters = await request.body.asJson;
    final identifier = parameters['identifier']!;
    final password = parameters['password']!;

    try {
      return Response.ok(AuthService().login(identifier, password));
    } catch (e) {
      return Response.forbidden(e.toString());
    }
  }
}
