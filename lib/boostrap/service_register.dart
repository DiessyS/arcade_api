import 'package:get_it/get_it.dart';

import '../models/event.dart';
import '../models/event_multi_marker.dart';
import '../models/marker.dart';
import '../models/user.dart';
import '../repository/core/repository.dart';
import '../service/auth_service.dart';
import '../service/curse_words/curse_words_service.dart';
import '../service/database/database_service.dart';
import '../service/event_multi_service.dart';
import '../service/event_service.dart';
import '../service/marker_service.dart';
import '../service/user_service.dart';

GetIt service = GetIt.instance;

void registerServices() {
  service.registerLazySingleton<DatabaseService>(
    () => DatabaseService(localPath: 'database'),
  );

  service.registerLazySingleton<UserService>(
    () => UserService(
      Repository<User>(
        service<DatabaseService>().database,
      ),
    ),
  );

  service.registerLazySingleton<EventService>(
    () => EventService(
      Repository<Event>(
        service<DatabaseService>().database,
      ),
    ),
  );

  service.registerLazySingleton<EventMultiService>(
    () => EventMultiService(
      Repository<EventMultiMarker>(
        service<DatabaseService>().database,
      ),
    ),
  );

  service.registerLazySingleton<MarkerService>(
    () => MarkerService(
      Repository<Marker>(
        service<DatabaseService>().database,
      ),
    ),
  );

  service.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  service.registerLazySingleton<CurseWordService>(
    () => CurseWordService(),
  );
}
