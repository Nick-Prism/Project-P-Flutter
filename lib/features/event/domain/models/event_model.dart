import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventTime;
  final String venue;
  final int maxAttendees;
  final List<String> registeredAttendees;
  final String? posterUrl;
  final String organizerId;
  final DateTime createdAt;
  final EventStatus status;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventTime,
    required this.venue,
    required this.maxAttendees,
    List<String>? registeredAttendees,
    this.posterUrl,
    required this.organizerId,
    DateTime? createdAt,
    this.status = EventStatus.upcoming,
  })  : this.registeredAttendees = registeredAttendees ?? [],
        this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventTime': eventTime,
      'venue': venue,
      'maxAttendees': maxAttendees,
      'registeredAttendees': registeredAttendees,
      'posterUrl': posterUrl,
      'organizerId': organizerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.toString(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json, [String? id]) {
    return Event(
      id: id ?? json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: (json['eventDate'] as Timestamp).toDate(),
      eventTime: json['eventTime'] as String,
      venue: json['venue'] as String,
      maxAttendees: json['maxAttendees'] as int,
      registeredAttendees: List<String>.from(json['registeredAttendees'] ?? []),
      posterUrl: json['posterUrl'] as String?,
      organizerId: json['organizerId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      status: EventStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => EventStatus.upcoming,
      ),
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    String? eventTime,
    String? venue,
    int? maxAttendees,
    List<String>? registeredAttendees,
    String? posterUrl,
    String? organizerId,
    DateTime? createdAt,
    EventStatus? status,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      venue: venue ?? this.venue,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      registeredAttendees: registeredAttendees ?? this.registeredAttendees,
      posterUrl: posterUrl ?? this.posterUrl,
      organizerId: organizerId ?? this.organizerId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  bool isUserRegistered(String userId) {
    return registeredAttendees.contains(userId);
  }
}

enum EventStatus { upcoming, ongoing, past }
