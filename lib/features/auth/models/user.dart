import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// App user model representing a user in the application
@freezed
abstract class AppUser with _$AppUser {
  /// Creates an instance of [AppUser]
  const factory AppUser({
    required String id,
    required String email,
    String? name,
    String? photoUrl,
    @Default('customer') String role,
  }) = _AppUser;

  /// Creates an [AppUser] from JSON map
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  /// Creates an empty [AppUser] instance
  factory AppUser.empty() => const AppUser(
        id: '',
        email: '',
      );
}
