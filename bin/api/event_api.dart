import 'package:arcade_repository/models/event.dart';
import 'package:arcade_repository/models/user.dart';
import 'package:shelf_plus/shelf_plus.dart';
import '../boostrap/service_register.dart';
import '../service/auth_service.dart';
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

    event.createdBy.target = user;

    try {
      service<EventService>().save(event);
    } catch (e) {
      return Response.badRequest(body: 'Erro ao cadastrar. Erro: ${e.toString()}');
    }

    return Response.ok('Cadastrado com sucesso');
  }
}
