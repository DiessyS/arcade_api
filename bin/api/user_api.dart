import 'package:arcade_repository/models/user.dart';
import '../boostrap/service_register.dart';
import '../service/user_service.dart';
import 'generic/generic_api.dart';

class UserApi extends GenericAPI<User> {
  UserApi({required super.router}) : super(path: 'user', service: service<UserService>());
}
