import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'
    show FirebaseStorage, SettableMetadata;

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadEventPoster(String eventId, File file) async {
    try {
      final ref = _storage.ref().child('event_posters/$eventId.jpg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'eventId': eventId},
      );

      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask.whenComplete(() => null);

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload event poster: $e');
    }
  }

  Future<void> deleteEventPoster(String eventId) async {
    try {
      final ref = _storage.ref().child('event_posters/$eventId.jpg');
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete event poster: $e');
    }
  }
}
