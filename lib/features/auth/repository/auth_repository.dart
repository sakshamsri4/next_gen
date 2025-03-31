import 'package:next_gen/features/auth/models/user.dart';

/// Repository interface for handling authentication operations
abstract class AuthRepository {
  /// Sign in a user with email and password
  Future<AppUser?> signInWithEmail(String email, String password);

  /// Sign up a new user with email, password, name, and role
  Future<AppUser?> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  );

  /// Sign in a user with Google authentication
  Future<AppUser?> signInWithGoogle();

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current authenticated user if any
  Future<AppUser?> getCurrentUser();
}
