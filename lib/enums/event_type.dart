enum EventType {
  initial,
  place,
  temp,
  limit;

  @override
  toString() {
    switch (this) {
      case EventType.initial:
        return 'initial';
      case EventType.place:
        return 'place';
      case EventType.temp:
        return 'temp';
      case EventType.limit:
        return 'limit';
      default:
        throw Exception('Tipo de evento desconhecido');
    }
  }

  static EventType fromString(String label) {
    switch (label) {
      case 'initial':
        return EventType.initial;
      case 'place':
        return EventType.place;
      case 'temp':
        return EventType.temp;
      case 'limit':
        return EventType.limit;
      default:
        throw Exception('Tipo de evento desconhecido');
    }
  }

  static bool managerOnlyEvents(String typeOfEvent) {
    return typeOfEvent == EventType.limit.toString() ||
        typeOfEvent == EventType.place.toString() ||
        typeOfEvent == EventType.initial.toString();
  }

  static DateTime getTempEventDate() {
    return DateTime.now().add(Duration(days: 1));
  }
}
