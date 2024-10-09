import 'package:arcade_api/models/event.dart';
import 'package:arcade_api/models/marker.dart';
import 'package:arcade_api/models/user.dart';
import 'package:arcade_api/repository/core/repository.dart';
import 'package:arcade_api/service/auth_service.dart';
import 'package:arcade_api/service/curse_words/curse_words_service.dart';
import 'package:arcade_api/service/database/database_service.dart';
import 'package:arcade_api/service/ldap_service.dart';
import 'package:arcade_api/service/models/event_service.dart';
import 'package:arcade_api/service/models/marker_service.dart';
import 'package:arcade_api/service/models/user_service.dart';
import 'package:arcade_api/service/path_finder/path_finder_service.dart';
import 'package:get_it/get_it.dart';

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

  service.registerLazySingleton<MarkerService>(
    () => MarkerService(
      Repository<Marker>(
        service<DatabaseService>().database,
      ),
    ),
  );

  service.registerLazySingleton<AuthService>(() => AuthService());
  service.registerLazySingleton<PathFinderService>(() => PathFinderService());
  service.registerLazySingleton<LdapService>(() => LdapService());
  service.registerLazySingleton<CurseWordService>(() => CurseWordService());
}
