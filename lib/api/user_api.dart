import 'package:shelf_plus/shelf_plus.dart';
import '../boostrap/service_register.dart';
import '../models/user.dart';
import '../service/auth_service.dart';
import '../service/user_service.dart';
import 'generic/generic_api.dart';

class UserApi extends GenericAPI<User> {
  UserApi({required super.router}) : super(path: 'user', service: service<UserService>());

  /*
  @override
  Response get(Request request, String id) {
    User? user = service<UserService>().getById(int.parse(id));

    if (user == null) {
      return Response.notFound('registro não encontrado');
    }

    if (!user.manager) {
      int idPayload = service<AuthService>().extractUserIdFromRequest(request);
      if (idPayload != user.id) {
        return Response.forbidden('Você não tem permissão para acessar este recurso');
      }
    }

    return super.get(request, id);
  }
   */

  /*
  @override
  Response getAll(Request request) {
    int idPayload = service<AuthService>().extractUserIdFromRequest(request);
    User user = service<UserService>().getById(idPayload)!;

    if (!user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    return super.getAll(request);
  }

  @override
  Future<Response> update(Request request, String id) async {
    int idPayload = service<AuthService>().extractUserIdFromRequest(request);
    User user = service<UserService>().getById(idPayload)!;

    if (idPayload != int.parse(id) || !user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    return super.update(request, id);
  }

  @override
  Future<Response> delete(Request request, String id) async {
    int idPayload = service<AuthService>().extractUserIdFromRequest(request);
    User user = service<UserService>().getById(idPayload)!;

    if (idPayload != int.parse(id) || !user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    return super.delete(request, id);
  }

   */

  Middleware onlyManagerMiddleware() => (Handler innerHandler) {
        return (Request request) async {
          int idPayload = service<AuthService>().extractUserIdFromRequest(request);
          User user = service<UserService>().getById(idPayload)!;

          if (!user.manager) {
            return Response.forbidden('Você não tem permissão para acessar este recurso');
          }

          return innerHandler(request);
        };
      };
}
