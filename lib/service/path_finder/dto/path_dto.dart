import 'package:arcade_api/models/event.dart';
import 'package:uuid/uuid.dart';

class PathDTO {
  String id = Uuid().v4();
  Event begin;
  Event end;

  PathDTO({
    required this.begin,
    required this.end,
  });
}
