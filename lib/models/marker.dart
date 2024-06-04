import 'package:objectbox/objectbox.dart';

@Entity()
class Marker {
  @Id()
  int id = 0;

  double latitude = 0.0;
  double longitude = 0.0;
  double altitude = 0.0;

  Marker();

  @override
  String toString() {
    return 'Marker{id: $id, latitude: $latitude, longitude: $longitude, altitude: $altitude}';
  }

  toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
    };
  }

  Marker.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
    altitude = json['altitude'].toDouble();
  }
}
