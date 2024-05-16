import 'dart:html';

import 'package:arcade_repository/models/event.dart';
import 'package:arcade_repository/models/user.dart';
import 'package:shelf_plus/shelf_plus.dart';
import '../boostrap/service_register.dart';
import '../service/auth_service.dart';
import '../service/curse_words/curse_words_service.dart';
import '../service/event_service.dart';
import '../service/user_service.dart';
import 'generic/generic_api.dart';

class EventApi extends GenericAPI<Event> {
  EventApi({required super.router}) : super(path: 'event', service: service<EventService>());

  @override
  Future<Response> save(Request request) async {
    final parameters = await request.body.asJson;

    Event event = Event.fromJson(parameters);
    String token = request.headers['Authorization'] ?? '';
    int userId = AuthService().extractUserIdFromToken(token);
    User user = service<UserService>().getById(userId)!;

    if (user.banned) {
      return Response.forbidden(
          'O acesso do usuario ${user.identifier} foi bloqueado, por favor entre em contato com o administrador');
    }

    if (service<CurseWordService>().containsCurseWord(event.name) ||
        service<CurseWordService>().containsCurseWord(event.description)) {
      user.banned = true;
      service<UserService>().update(user);
      return Response.badRequest(body: 'Não foi possivel cadastrar o evento');
    }

    event.createdBy.target = user;

    try {
      service<EventService>().save(event);
    } catch (e) {
      return Response.badRequest(body: 'Erro ao cadastrar. Erro: ${e.toString()}');
    }

    return Response.ok('Cadastrado com sucesso');
  }

  @override
  Future<Response> delete(Request request, String id) async {
    int idPayload = service<AuthService>().extractUserIdFromRequest(request);
    User user = service<UserService>().getById(idPayload)!;

    Event? entity = service<EventService>().getById(int.parse(id));

    if (entity == null) {
      return Response.notFound('registro não encontrado');
    }

    if (entity.createdBy.target?.id != idPayload && !user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    service<EventService>().delete(entity);

    return Response.ok('Deletado com sucesso');
  }
}
