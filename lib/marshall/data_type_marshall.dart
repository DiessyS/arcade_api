import '../models/event.dart';
import '../models/event_multi_marker.dart';
import '../models/marker.dart';
import '../models/user.dart';

class DataTypeMarshall<T> {
  List subTypes = [User, Event, EventMultiMarker, Marker];

  T fromJson(Map<String, dynamic> json) {
    if (T == User) {
      return User.fromJson(json) as T;
    } else if (T == Event) {
      return Event.fromJson(json) as T;
    } else if (T == EventMultiMarker) {
      return EventMultiMarker.fromJson(json) as T;
    } else if (T == Marker) {
      return Marker.fromJson(json) as T;
    } else {
      throw Exception('Unknown type');
    }
  }
}
