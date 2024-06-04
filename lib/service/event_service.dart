import 'package:arcade_api/enums/event_type.dart';
import 'package:arcade_api/objectbox.g.dart';

import '../models/event.dart';
import 'generic/generic_service.dart';

class EventService extends GenericService<Event> {
  EventService(super.repository);

  getByEventType(EventType eventType) {
    var query = repository.box.query(Event_.eventType.equals(eventType.toString())).build();
    return query.find();
  }

  deleteByEventType(EventType eventType) {
    var query = repository.box.query(Event_.eventType.equals(eventType.toString())).build();
    query.remove();
  }

  filterTempEvents(List<Event> events) {
    return events
        .where(
          (element) => element.createdAt.isBefore(
            EventType.getTempEventDate(),
          ),
        )
        .toList();
  }
}
