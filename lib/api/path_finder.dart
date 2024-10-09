import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/models/event.dart';
import 'package:arcade_api/service/path_finder/path_finder_service.dart';
import 'package:shelf_plus/shelf_plus.dart';

class PathFinderAPI {
  RouterPlus router;

  PathFinderAPI({required this.router}) {
    router.post('/find', _find);
  }

  _find(Request request) async {
    final parameters = await request.body.asJson;

    final Event origin = Event.fromJson(parameters['origin']);
    final Event destination = Event.fromJson(parameters['destination']);

    return await service<PathFinderService>().find(origin, destination);
  }
}
