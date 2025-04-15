import '../models/event_model.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents(EventStatus status);
  Future<Event> getEventById(String id);
  Future<String> createEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
  Future<void> registerForEvent(String eventId, String userId);
  Future<List<Event>> getRegisteredEvents(String userId);
  Stream<List<Event>> watchEvents(EventStatus status);
}
