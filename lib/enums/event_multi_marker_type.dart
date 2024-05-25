enum EventMultiMarkerType {
  limit,
  road;

  @override
  toString() {
    switch (this) {
      case EventMultiMarkerType.limit:
        return 'limit';
      case EventMultiMarkerType.road:
        return 'road';
      default:
        return 'limit';
    }
  }

  static EventMultiMarkerType fromString(String label) {
    switch (label) {
      case 'limit':
        return EventMultiMarkerType.limit;
      case 'road':
        return EventMultiMarkerType.road;
      default:
        return EventMultiMarkerType.limit;
    }
  }
}
