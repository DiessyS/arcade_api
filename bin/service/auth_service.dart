import 'package:arcade_repository/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../boostrap/service_register.dart';
import 'user_service.dart';

class AuthService {
  login(String identifier, String password) {
    User user = service<UserService>().getAll().firstWhere((element) => element.identifier == identifier);

    if (user.banned) {
      return Response.forbidden(
          'O acesso do usuario ${user.identifier} foi bloqueado, por favor entre em contato com o administrador');
    }

    //Todo: checagem pelo ldap
    if (false) {
      throw Exception("Usuário ou senha inválidos");
    }

    JWT jwt = JWT(
      {
        'id': user.id,
        'identifier': user.identifier,
        'name': user.name,
      },
    );

    return jwt.sign(SecretKey(_getServerSecretKey()));
  }

  isTokenValid(String token) {
    try {
      JWT.verify(token, SecretKey(_getServerSecretKey()));
      return true;
    } catch (e) {
      return false;
    }
  }

  int extractUserIdFromToken(String token) {
    JWT jwt = JWT.decode(token);
    return jwt.payload['id'];
  }

  int extractUserIdFromRequest(Request request) {
    String token = request.headers['Authorization'] ?? '';
    return extractUserIdFromToken(token);
  }

  _getServerSecretKey() {
    //Todo: buscar a chave on system env
    return "VmvQtBbXXVSzTyv5yL2dmfvrf7QGunEt";
  }
}
