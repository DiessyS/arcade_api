import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/enums/event_type.dart';
import 'package:arcade_api/models/event.dart';
import 'package:arcade_api/models/user.dart';
import 'package:arcade_api/service/curse_words/curse_words_service.dart';
import 'package:arcade_api/service/models/event_service.dart';
import 'package:arcade_api/service/models/user_service.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'generic/request_handler.dart';

class EventApi extends RequestHandler<Event> {
  RouterPlus router;

  EventApi({required this.router}) {
    router.post('/event', save);
    router.delete('/event/<id>', delete);
    router.get('/event/type/<type>', getByEventType);
    router.delete('/event/type/<type>', deleteByEventType);
  }

  Future<Response> save(Request request) async {
    try {
      final parameters = await request.body.asJson;

      final Event event = Event.fromJson(parameters);
      final User user = getUserFromRequest(request);

      if (user.banned) {
        return Response.forbidden('O acesso do usuario ${user.identifier} foi bloqueado.');
      }

      if (EventType.managerOnlyEvents(event.eventType) && !user.manager) {
        return Response.forbidden('Você não tem permissão para acessar este recurso.');
      }

      if (!user.manager && service<CurseWordService>().containsCurseWord('${event.identifier} ${event.reference}')) {
        service<UserService>().banUser(user);
        return Response.forbidden(
          'O evento não pode ser cadastrado pois contém palavras que podem ser ofensivas.',
        );
      }

      event.createdBy.target = user;
      event.createdAt = DateTime.now();

      try {
        service<EventService>().save(event);
      } catch (e) {
        return Response.badRequest(body: 'Erro ao cadastrar. ${e.toString()}');
      }

      return Response.ok('Cadastrado com sucesso.');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao cadastrar evento. ${e.toString()}');
    }
  }

  Future<Response> delete(Request request, String id) async {
    try {
      final User user = getUserFromRequest(request);
      final Event? entity = service<EventService>().getById(int.parse(id));

      if (entity == null) {
        return Response.notFound('registro não encontrado.');
      }

      if (entity.createdBy.target?.id != user.id && !user.manager) {
        return Response.forbidden('Você não tem permissão para acessar este recurso.');
      }

      service<EventService>().delete(entity);

      return Response.ok('Deletado com sucesso.');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao deletar evento. ${e.toString()}');
    }
  }

  getByEventType(Request request, String type) async {
    try {
      final EventType eventType = EventType.fromString(type);
      List<Event> events = await service<EventService>().getByEventType(eventType);
      return events;
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao buscar eventos. ${e.toString()}');
    }
  }

  deleteByEventType(Request request, String type) async {
    try {
      if (!isUserManager(request)) {
        return Response.forbidden('Você não tem permissão para acessar este recurso');
      }
      service<EventService>().deleteByEventType(EventType.fromString(type));
      return Response.ok('Deletados com sucesso');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao deletar eventos. ${e.toString()}');
    }
  }
}
