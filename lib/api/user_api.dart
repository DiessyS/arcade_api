import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/models/user.dart';
import 'package:arcade_api/service/models/user_service.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'generic/request_handler.dart';

class UserApi extends RequestHandler<User> {
  RouterPlus router;

  UserApi({required this.router}) {
    router.get('/user', getAll);
    router.put('/user/<id>', update);
    router.delete('/user/<id>', delete);
  }

  getAll(Request request) {
    try {
      if (!isUserManager(request)) {
        return Response.forbidden('Você não tem permissão para acessar este recurso');
      }
      return service<UserService>().getAll();
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao buscar usuários. ${e.toString()}');
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      if (!isUserManager(request)) {
        return Response.forbidden('Você não tem permissão para acessar este recurso');
      }

      final parameters = await request.body.asJson;
      User? entity = service<UserService>().getById(int.parse(id));

      if (entity == null) {
        return Response.notFound('registro não encontrado');
      }

      bool banned = parameters['banned'] == "true";

      entity.banned = banned;

      try {
        service<UserService>().update(entity);
      } catch (e) {
        return Response.badRequest(body: 'Erro ao atualizar. Erro: ${e.toString()}');
      }

      return Response.ok('Atualizado com sucesso');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao atualizar usuário. ${e.toString()}');
    }
  }

  Future<Response> delete(Request request, String id) async {
    try {
      User user = getUserFromRequest(request);

      if (user.id != int.parse(id) && !user.manager) {
        return Response.forbidden('Você não tem permissão para acessar este recurso');
      }

      User? entity = service<UserService>().getById(int.parse(id));

      if (entity == null) {
        return Response.notFound('registro não encontrado');
      }

      service<UserService>().delete(entity);

      return Response.ok('Deletado com sucesso');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao deletar usuário. ${e.toString()}');
    }
  }
}
