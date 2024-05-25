import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  @Unique()
  String identifier = '';

  String name = '';

  bool banned = false;
  bool manager = true;
  bool crudOnTempEvents = true;
  bool crudOnPermEvents = true;

  User();

  @override
  String toString() {
    return 'User{id: $id, identifier: $identifier, name: $name, banned: $banned, crudOnTempEvents: $crudOnTempEvents, crudOnPermEvents: $crudOnPermEvents}';
  }

  toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'name': name,
      'banned': banned,
      'crudOnTempEvents': crudOnTempEvents,
      'crudOnPermEvents': crudOnPermEvents,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
  }
}
