Hey, I'm building a cross-platform event planner app for college students and organizers — codename: Project P.

Here's a breakdown of what I'd like you to help me build:

Project Overview
Build a mobile application using Flutter that allows students to:

View a list of upcoming/past/registered events

Register for events (with name, email, USN, phone number)

Receive a QR code after successful registration

Scan QR codes for attendance tracking (organizers only)

Modules & Features
User authentication using OTP (phone/email)

Profile creation for students

Organizer event creation screen (name, date, time, venue, poster upload)

Event listing and details view for students

Event registration with Firestore

QR code generation (per user, per event)

QR scanner + attendance logging (for organizers)

Suggested Folder Structure
Project-P/
├── lib/
│   ├── main.dart
│   ├── features/
│   │   └── event/
│   │       ├── domain/
│   │       │   ├── models/
│   │       │   │   └── event_model.dart
│   │       │   └── repositories/
│   │       │   └── event_repository.dart
│   │       ├── presentation/
│   │       │   ├── providers/
│   │       │   │   └── event_provider.dart
│   │       │   ├── screens/
│   │       │   │   ├── event_creation_screen.dart
│   │       │   │   ├── event_list_screen.dart
│   │       │   │   └── event_detail_screen.dart
│   │       │   └── widgets/
│   │       │   └── event_card.dart
│   │       └── data/
│   │           ├── repositories/
│   │           │   └── firebase_event_repository.dart
│   │           └── services/
│   │               └── storage_service.dart
│   ├── core/
│   │   ├── navigation/
│   │   │   └── app_router.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   └── date_time_utils.dart
│   │   └── widgets/
│   │   └── loading_overlay.dart
│   └── services/
│   └── qr_code_service.dart
├── pubspec.yaml
└── README.md


Let's start by building the user authentication flow with OTP and profile creation. After that, we can tackle the event creation UI and database model.