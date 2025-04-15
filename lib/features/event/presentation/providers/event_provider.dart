import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/models/event_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EventProvider with ChangeNotifier {
  final EventRepository _repository;
  Map<EventStatus, List<Event>> _events = {
    EventStatus.upcoming: [],
    EventStatus.ongoing: [],
    EventStatus.past: [],
  };
  bool _isLoading = false;
  String? _error;

  EventProvider(this._repository);

  List<Event> get events => _events.values.expand((e) => e).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _setLoading(true);
    try {
      final upcomingEvents = await _repository.getEvents(EventStatus.upcoming);
      _events[EventStatus.upcoming] = upcomingEvents;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  List<Event> getEventsByStatus(EventStatus status) => _events[status] ?? [];

  Future<void> loadEvents(EventStatus status) async {
    try {
      _setLoading(true);
      final events = await _repository.getEvents(status);
      _events[status] = events;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createEvent(Event event, File? posterImage) async {
    _setLoading(true);
    try {
      final eventId = await _repository.createEvent(event);
      if (posterImage != null) {
        // TODO: Upload poster image and update event
      }
      await loadEvents(event.status);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      _setLoading(true);
      await _repository.updateEvent(event);
      await loadEvents(event.status);
      _error = null;
    } catch (e) {
      _error = e.toString();
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerForEvent(String eventId, String userId) async {
    try {
      _setLoading(true);
      await _repository.registerForEvent(eventId, userId);

      // Update local state
      for (final status in _events.keys) {
        _events[status] = _events[status]?.map((event) {
              if (event.id == eventId) {
                return event.copyWith(
                  registeredAttendees: [...event.registeredAttendees, userId],
                );
              }
              return event;
            }).toList() ??
            [];
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<List<Event>> watchEvents(EventStatus status) {
    return _repository.watchEvents(status);
  }
}
