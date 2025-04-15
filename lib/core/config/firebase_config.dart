import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConfig {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static FirebaseAuth get auth => _auth;
  static GoogleSignIn get googleSignIn => _googleSignIn;
  static FirebaseFirestore get firestore => _firestore;
  static FirebaseStorage get storage => _storage;

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Enable offline persistence for Firestore
    await _firestore.enablePersistence();

    // Configure Google Sign-In
    _googleSignIn.signInSilently();
  }
}
