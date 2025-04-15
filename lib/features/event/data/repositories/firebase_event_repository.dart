import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/models/event_model.dart';

class FirebaseEventRepository implements EventRepository {
  final FirebaseFirestore _firestore;

  FirebaseEventRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection =>
      _firestore.collection('events');

  @override
  Future<List<Event>> getEvents(EventStatus status) async {
    try {
      final query = _eventsCollection
          .where('status', isEqualTo: status.toString())
          .where('isActive', isEqualTo: true)
          .orderBy('eventDate');

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Event.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Future<String> createEvent(Event event) async {
    try {
      final docRef = await _eventsCollection.add(event.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<Event> getEventById(String id) async {
    try {
      final doc = await _eventsCollection.doc(id).get();
      if (!doc.exists) {
        throw Exception('Event not found');
      }
      return Event.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      if (event.id == null) throw Exception('Event ID cannot be null');
      await _eventsCollection.doc(event.id).update(event.toJson());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _eventsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  @override
  Future<void> registerForEvent(String eventId, String userId) async {
    try {
      final batch = _firestore.batch();
      final eventRef = _eventsCollection.doc(eventId);
      final registrationRef = eventRef.collection('registrations').doc(userId);

      // Add to registeredAttendees array
      batch.update(eventRef, {
        'registeredAttendees': FieldValue.arrayUnion([userId]),
      });

      // Create registration document
      batch.set(registrationRef, {
        'userId': userId,
        'registeredAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to register for event: $e');
    }
  }

  @override
  Future<List<Event>> getRegisteredEvents(String userId) async {
    try {
      final query = _eventsCollection
          .where('registeredAttendees', arrayContains: userId)
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Event.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch registered events: $e');
    }
  }

  @override
  Stream<List<Event>> watchEvents(EventStatus status) {
    return _eventsCollection
        .where('status', isEqualTo: status.toString())
        .where('isActive', isEqualTo: true)
        .orderBy('eventDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Event.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }
}
