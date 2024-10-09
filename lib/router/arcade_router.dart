import 'package:arcade_api/api/path_finder.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../api/auth_api.dart';
import '../api/event_api.dart';
import '../api/user_api.dart';

class ArcadeRouter {
  RouterPlus router;
  late AuthAPI authApi;
  late EventApi eventApi;
  late UserApi userApi;
  late PathFinderAPI pathFinderAPI;

  ArcadeRouter({required this.router}) {
    userApi = UserApi(router: router);
    eventApi = EventApi(router: router);
    authApi = AuthAPI(router: router);
    pathFinderAPI = PathFinderAPI(router: router);

    router.get('/ping', ping);
    router.all('/<ignored|.*>', _notFound);
  }

  _notFound(Request request) {
    return Response.notFound('Not found');
  }

  ping(Request request) {
    return Response.ok('pong');
  }
}
