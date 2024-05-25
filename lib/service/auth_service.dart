import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../boostrap/service_register.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  String login(String identifier, String password) {
    User user = service<UserService>().getAll().firstWhere((element) => element.identifier == identifier);

    if (user.banned) {
      throw Exception(
          'O acesso do usuario ${user.identifier} foi bloqueado, por favor entre em contato com o administrador');
    }

    if (false) {
      //Todo: checagem pelo ldap
      throw Exception("Usuário ou senha inválidos");
    }

    JWT jwt = JWT({'id': user.id});
    String token = jwt.sign(SecretKey(_getServerSecretKey()));

    return json.encode({'token': token, 'user': user.toJson()});
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
