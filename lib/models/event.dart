import 'package:hashlib/hashlib.dart';
import 'package:latlong2/latlong.dart';
import 'package:objectbox/objectbox.dart';

import '../enums/event_type.dart';
import 'marker.dart';
import 'user.dart';

@Entity()
class Event {
  @Id()
  int id = 0;

  String identifier = "";
  String reference = "";
  String eventType = EventType.place.toString();

  late final marker = ToOne<Marker>();
  final createdBy = ToOne<User>();

  @Property(type: PropertyType.date)
  DateTime createdAt = DateTime.now();

  Event();

  int getLatLongIdentifier() {
    final String latitude = marker.target?.latitude.toStringAsFixed(5) ?? '';
    final String longitude = marker.target?.longitude.toStringAsFixed(5) ?? '';
    return crc64code('$latitude $longitude');
  }

  LatLng asLatLng() {
    return (marker.target?.toLatLng())!;
  }

  @override
  String toString() {
    return 'Event{id: $id, identifier: $identifier, description: $reference, eventType: $eventType}';
  }

  toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'reference': reference,
      'eventType': eventType,
      'marker': marker.target?.toJson(),
      'createdBy': createdBy.target?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Event.fromJson(Map<String, dynamic> map) {
    identifier = map['identifier'];
    reference = map['reference'];
    eventType = map['eventType'];
    marker.target = Marker.fromJson(map['marker']);
  }
}
