import 'package:shelf_plus/shelf_plus.dart';
import '../boostrap/service_register.dart';
import '../models/event_multi_marker.dart';
import '../models/user.dart';
import '../service/auth_service.dart';
import '../service/event_multi_service.dart';
import '../service/user_service.dart';
import 'generic/generic_api.dart';

class EventMultiApi extends GenericAPI<EventMultiMarker> {
  EventMultiApi({required super.router}) : super(path: 'event_multi', service: service<EventMultiService>());

  @override
  Future<Response> save(Request request) async {
    String token = request.headers['Authorization'] ?? '';
    int userId = AuthService().extractUserIdFromToken(token);
    User user = service<UserService>().getById(userId)!;

    if (!user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    final parameters = await request.body.asJson;
    EventMultiMarker event = EventMultiMarker.fromJson(parameters);

    event.createdBy.target = user;

    try {
      service<EventMultiService>().save(event);
    } catch (e) {
      return Response.badRequest(body: 'Erro ao cadastrar. Erro: ${e.toString()}');
    }

    return Response.ok('Cadastrado com sucesso');
  }

  @override
  Future<Response> delete(Request request, String id) async {
    int idPayload = service<AuthService>().extractUserIdFromRequest(request);
    User user = service<UserService>().getById(idPayload)!;

    if (!user.manager) {
      return Response.forbidden('Você não tem permissão para acessar este recurso');
    }

    return super.delete(request, id);
  }
}
