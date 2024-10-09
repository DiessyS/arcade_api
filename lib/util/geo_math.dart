import 'dart:math';
import 'package:latlong2/latlong.dart';

class GeoMath {
  double _haversineDistance(LatLng p1, LatLng p2) {
    const R = 6371000;
    final double dLat = (p2.latitude - p1.latitude) * pi / 180.0;
    final double dLon = (p2.longitude - p1.longitude) * pi / 180.0;

    final double lat1 = p1.latitude * pi / 180.0;
    final double lat2 = p2.latitude * pi / 180.0;

    final double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  double distanceToSegment(LatLng target, LatLng begin, LatLng end) {
    final double x1 = begin.latitude, y1 = begin.longitude;
    final double x2 = end.latitude, y2 = end.longitude;
    final double x0 = target.latitude, y0 = target.longitude;

    double t = ((x0 - x1) * (x2 - x1) + (y0 - y1) * (y2 - y1)) / ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));

    if (t < 0) t = 0;
    if (t > 1) t = 1;

    final double closestX = x1 + t * (x2 - x1);
    final double closestY = y1 + t * (y2 - y1);

    final LatLng closestPoint = LatLng(closestX, closestY);

    return _haversineDistance(target, closestPoint);
  }

  LatLng createDivergence(LatLng begin, LatLng end, LatLng location) {
    final double vx = end.latitude - begin.latitude;
    final double vy = end.longitude - begin.longitude;

    final double wx = location.latitude - begin.latitude;
    final double wy = location.longitude - begin.longitude;

    final double dotV = vx * vx + vy * vy;
    final double dotW = wx * vx + wy * vy;

    double t = dotW / dotV;

    t = max(0, min(1, t));

    final double closestX = begin.latitude + t * vx;
    final double closestY = begin.longitude + t * vy;

    return LatLng(closestX, closestY);
  }
}
