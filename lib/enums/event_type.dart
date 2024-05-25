enum EventType {
  place,
  temp;

  @override
  toString() {
    switch (this) {
      case EventType.place:
        return 'place';
      case EventType.temp:
        return 'temp';
      default:
        return 'place';
    }
  }

  static EventType fromString(String label) {
    switch (label) {
      case 'place':
        return EventType.place;
      case 'temp':
        return EventType.temp;
      default:
        return EventType.place;
    }
  }
}
