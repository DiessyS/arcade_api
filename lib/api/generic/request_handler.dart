import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/models/user.dart';
import 'package:arcade_api/service/auth_service.dart';
import 'package:arcade_api/service/user_service.dart';
import 'package:shelf_plus/shelf_plus.dart';

class RequestHandler<T> {
  User getUserFromRequest(Request request) {
    String? token = request.headers['Authorization'];

    if (token == null) {
      throw Exception('A header Authorization é obrigatória');
    }

    int userId = AuthService().extractUserIdFromToken(token);
    User? user = service<UserService>().getById(userId);

    if (user == null) {
      throw Exception('Usuário não encontrado');
    }

    return user;
  }

  isUserManager(Request request) {
    User user = getUserFromRequest(request);
    return user.manager;
  }
}
