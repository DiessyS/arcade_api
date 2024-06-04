import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  @Unique()
  String identifier = '';

  String name = '';

  bool banned = false;
  bool manager = false;

  User();

  @override
  String toString() {
    return 'User{id: $id, identifier: $identifier, name: $name, banned: $banned}';
  }

  toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'name': name,
      'banned': banned,
      'manager': manager,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
  }
}
