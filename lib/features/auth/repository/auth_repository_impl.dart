import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_gen/features/auth/models/user.dart';
import 'package:next_gen/features/auth/repository/auth_repository.dart';

/// Implementation of [AuthRepository] using
/// Firebase Authentication and Firestore
class AuthRepositoryImpl implements AuthRepository {
  /// Constructor for [AuthRepositoryImpl]
  const AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  /// Firebase Authentication instance
  final FirebaseAuth _firebaseAuth;

  /// Firestore instance
  final FirebaseFirestore _firestore;

  /// Collection reference for users in Firestore
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _getUserData(userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<AppUser?> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) return null;

      // Create AppUser object
      final appUser = AppUser(
        id: uid,
        email: email,
        name: name,
        role: role,
      );

      // Save to Firestore
      await _usersCollection.doc(uid).set(appUser.toJson());

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    // This is a placeholder for Google Sign In implementation
    throw UnimplementedError('Google Sign In is not implemented yet');
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return _getUserData(user.uid);
  }

  /// Helper method to get user data from Firestore
  Future<AppUser?> _getUserData(String? uid) async {
    if (uid == null) return null;

    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;

    return AppUser.fromJson(doc.data()!);
  }

  /// Helper method to handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email format');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
