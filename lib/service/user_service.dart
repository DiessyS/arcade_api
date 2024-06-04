import 'package:arcade_api/objectbox.g.dart';

import '../models/user.dart';
import 'generic/generic_service.dart';

class UserService extends GenericService<User> {
  UserService(super.repository);

  User? getByIdentifier(String identifier) {
    var query = repository.box.query(User_.identifier.equals(identifier)).build();
    return query.findFirst();
  }

  banUser(User user) {
    user.banned = true;
    update(user);
  }
}
