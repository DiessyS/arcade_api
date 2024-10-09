import 'dart:math';

import 'package:arcade_api/boostrap/service_register.dart';
import 'package:arcade_api/enums/event_type.dart';
import 'package:arcade_api/models/event.dart';
import 'package:arcade_api/models/marker.dart' as m;
import 'package:arcade_api/service/models/event_service.dart';
import 'package:arcade_api/util/geo_math.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:latlong2/latlong.dart';
import 'package:sector/sector.dart';

import 'dto/path_dto.dart';

class PathFinderService {
  late final GeoMath geoMath;

  PathFinderService() {
    geoMath = GeoMath();
  }

  Future<List<Event>> find(Event origin, Event destination) async {
    List<PathDTO> paths = await _buildPaths();

    paths = _connectPointsOfInterest(paths, origin, destination);

    final WeightedWalkable graph = _buildGraph(paths);
    final Dijkstra dijkstra = Dijkstra();

    final bestRoute = dijkstra.findBestPath(
      graph,
      origin.getLatLongIdentifier(),
      Goal<int>.node(
        destination.getLatLongIdentifier(),
      ),
    );
    final List<int> path = bestRoute.$1.nodes.cast<int>();
    final List<Event> events = await _drawPolylineByIdentifiers(paths, path);

    return events;
  }

  Future<List<Event>> _drawPolylineByIdentifiers(List<PathDTO> path, List<int> localIdentifiers) async {
    final List<Event> events = [];

    for (int localIdentifier in localIdentifiers) {
      try {
        final PathDTO pathDTO = path.firstWhere((element) => element.begin.getLatLongIdentifier() == localIdentifier);
        events.add(pathDTO.begin);
      } catch (e) {/* ignored */}
      try {
        final PathDTO pathDTO = path.firstWhere((element) => element.end.getLatLongIdentifier() == localIdentifier);
        events.add(pathDTO.end);
      } catch (e) {/* ignored */}
    }

    return events;
  }

  List<PathDTO> _connectPointsOfInterest(List<PathDTO> paths, Event origin, Event destination) {
    // ---------------------------------------------------------------
    // connect origin with the closest path
    final PathDTO closetPathOrigin = _closestPathToLocation(paths, origin.asLatLng());
    final LatLng divergencePointStart = geoMath.createDivergence(
      closetPathOrigin.begin.asLatLng(),
      closetPathOrigin.end.asLatLng(),
      origin.asLatLng(),
    );
    final PathDTO divergenceOrigin = PathDTO(
      begin: Event()..marker.target = m.Marker.fromLatLng(divergencePointStart),
      end: closetPathOrigin.end,
    );

    paths.removeWhere((element) => element.id == closetPathOrigin.id);
    paths.insert(0, divergenceOrigin);

    final PathDTO o = PathDTO(begin: origin, end: divergenceOrigin.begin);
    paths.insert(0, o);

    // ---------------------------------------------------------------
    // connect origin with the closest path
    final PathDTO closetPathDestination = _closestPathToLocation(paths, destination.asLatLng());

    LatLng divergencePoint = geoMath.createDivergence(
      closetPathDestination.begin.asLatLng(),
      closetPathDestination.end.asLatLng(),
      destination.asLatLng(),
    );

    PathDTO divergenceDestination = PathDTO(
      begin: closetPathDestination.begin,
      end: Event()..marker.target = m.Marker.fromLatLng(divergencePoint),
    );

    divergenceDestination.id = closetPathDestination.id;

    paths.removeWhere((element) => element.id == closetPathDestination.id);
    paths.add(divergenceDestination);

    PathDTO dest = PathDTO(begin: divergenceDestination.end, end: destination);
    paths.add(dest);

    return paths;
  }

  WeightedWalkable _buildGraph(List<PathDTO> paths) {
    final latlong.Distance distance = latlong.Distance();
    final Map<int, List<(int, double)>> graph = {};

    for (PathDTO path in paths) {
      final int beginLocalId = path.begin.getLatLongIdentifier();
      final int endLocalId = path.end.getLatLongIdentifier();
      final double dis = distance(path.begin.asLatLng(), path.end.asLatLng());

      if (graph[beginLocalId] == null) {
        graph[beginLocalId] = [];
      }

      graph[beginLocalId]?.add((endLocalId, dis));
    }

    return WeightedWalkable.from(graph);
  }

  Future<List<PathDTO>> _buildPaths() async {
    final List<Event> events = await service<EventService>().getByEventType(EventType.path);
    final List<String> uniqueIds = [];
    final List<PathDTO> paths = [];

    for (Event event in events) {
      if (!uniqueIds.contains(event.identifier)) {
        uniqueIds.add(event.identifier);
      }
    }

    for (String uniqueId in uniqueIds) {
      final List<Event> pathEvents = events.where((element) => element.identifier == uniqueId).toList();

      if (pathEvents.length != 2) {
        throw Exception("Wrong path size");
      }

      final PathDTO path = PathDTO(begin: pathEvents[0], end: pathEvents[1]);
      paths.add(path);
    }

    return paths;
  }

  PathDTO _closestPathToLocation(List<PathDTO> paths, LatLng location) {
    PathDTO? closestPath;
    double minDistance = double.infinity;

    for (PathDTO path in paths) {
      final double distance = geoMath.distanceToSegment(
        location,
        path.begin.asLatLng(),
        path.end.asLatLng(),
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestPath = path;
      }
    }

    return closestPath!;
  }

  // double haversineDistance(LatLng p1, LatLng p2) {
  //   const R = 6371000;
  //   final double dLat = (p2.latitude - p1.latitude) * pi / 180.0;
  //   final double dLon = (p2.longitude - p1.longitude) * pi / 180.0;
  //
  //   final double lat1 = p1.latitude * pi / 180.0;
  //   final double lat2 = p2.latitude * pi / 180.0;
  //
  //   final double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  //   final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //
  //   return R * c;
  // }

  // double distanceToSegment(LatLng target, LatLng begin, LatLng end) {
  //   final double x1 = begin.latitude, y1 = begin.longitude;
  //   final double x2 = end.latitude, y2 = end.longitude;
  //   final double x0 = target.latitude, y0 = target.longitude;
  //
  //   double t = ((x0 - x1) * (x2 - x1) + (y0 - y1) * (y2 - y1)) / ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  //
  //   if (t < 0) t = 0;
  //   if (t > 1) t = 1;
  //
  //   final double closestX = x1 + t * (x2 - x1);
  //   final double closestY = y1 + t * (y2 - y1);
  //
  //   final LatLng closestPoint = LatLng(closestX, closestY);
  //
  //   return haversineDistance(target, closestPoint);
  // }

  // PathDTO createDivergence(PathDTO path, LatLng location) {
  //   double vx = path.end.asLatLng().latitude - path.begin.asLatLng().latitude;
  //   double vy = path.end.asLatLng().longitude - path.begin.asLatLng().longitude;
  //
  //   double wx = location.latitude - path.begin.asLatLng().latitude;
  //   double wy = location.longitude - path.begin.asLatLng().longitude;
  //
  //   double dotV = vx * vx + vy * vy;
  //   double dotW = wx * vx + wy * vy;
  //
  //   double t = dotW / dotV;
  //
  //   t = max(0, min(1, t));
  //
  //   double closestX = path.begin.asLatLng().latitude + t * vx;
  //   double closestY = path.begin.asLatLng().longitude + t * vy;
  //
  //   LatLng closestPoint = LatLng(closestX, closestY);
  //
  //   PathDTO divergence = PathDTO(
  //     begin: path.begin,
  //     end: Event()..marker.target = m.Marker.fromLatLng(closestPoint),
  //   );
  //
  //   divergence.id = path.id;
  //
  //   return divergence;
  // }
}
