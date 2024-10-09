import 'dart:convert';

import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/models/user.dart';
import 'package:arcade_api/service/ldap_service.dart';
import 'package:arcade_api/service/models/user_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf_plus/shelf_plus.dart';

class AuthService {
  //todo: remover esse método
  Future<User> criarNovoUsuarioLdap(String identifier) async {
    User user = await service<LdapService>().getUserFromLdap(identifier);
    service<UserService>().save(user);
    return user;
  }

  Future<String> login(String identifier, String password) async {
    if (!(await service<LdapService>().authenticate(identifier, password))) {
      throw Exception("Usuário ou senha inválidos");
    }

    User? user = service<UserService>().getByIdentifier(identifier);

    user ??= await criarNovoUsuarioLdap(identifier);

    if (user.banned) {
      throw Exception('O acesso do usuario ${user.identifier} foi bloqueado');
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
