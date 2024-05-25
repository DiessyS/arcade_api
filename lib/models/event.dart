import 'package:objectbox/objectbox.dart';

import '../enums/event_type.dart';
import 'marker.dart';
import 'user.dart';

@Entity()
class Event {
  @Id()
  int id = 0;

  String name = "";
  String na2me = "";
  String description = '';
  String eventType = EventType.place.toString();

  final marker = ToOne<Marker>();
  final createdBy = ToOne<User>();

  Event();

  @override
  String toString() {
    return 'Event{id: $id, name: $name, description: $description, eventType: $eventType}';
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'eventType': eventType,
      'marker': marker.target?.toJson(),
      'createdBy': createdBy.target?.toJson(),
    };
  }

  Event.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    description = map['description'];
    eventType = map['eventType'];
    marker.target = Marker.fromJson(map['marker']);
  }
}
