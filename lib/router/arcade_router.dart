import 'package:shelf_plus/shelf_plus.dart';

import '../api/auth_api.dart';
import '../api/event_api.dart';
import '../api/event_multi_api.dart';
import '../api/user_api.dart';

class ArcadeRouter {
  RouterPlus router;
  late AuthAPI authApi;
  late EventApi eventApi;
  late EventMultiApi eventMultiApi;
  late UserApi userApi;

  ArcadeRouter({required this.router}) {
    userApi = UserApi(router: router);
    eventApi = EventApi(router: router);
    eventMultiApi = EventMultiApi(router: router);

    authApi = AuthAPI(router: router);

    router.all('/<ignored|.*>', _notFound);
  }

  _notFound(Request request) {
    return Response.notFound('Not found');
  }
}
