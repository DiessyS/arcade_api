import 'package:arcade_api/models/user.dart';

class LdapService {
  Future<bool> authenticate(String username, String password) async {
    // simulando uma chamada para um servidor LDAP
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<User> getUserFromLdap(String username) async {
    // simulando uma chamada para um servidor LDAP e verificando se o usuário é um professor
    await Future.delayed(Duration(seconds: 1));

    User user = User();
    user.identifier = username;
    user.manager = true; //checar se é professor
    user.name = "Fulano de Tal"; // pegar o nome do usuário
    return user;
  }
}
