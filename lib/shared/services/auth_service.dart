import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

final authProvider = StateNotifierProvider<AuthService, User?>((ref) {
  final users = ref.watch(userProvider);
  return AuthService(users);
});

class AuthService extends StateNotifier<User?> {
  final List<User> _users;
  AuthService(this._users) : super(null);

  String? login(String email, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      if (user.status == UserStatus.blocked ||
          user.status == UserStatus.suspended) {
        return 'Your account is suspended. Contact support.';
      }

      state = user;
      return null; // Success
    } catch (e) {
      return 'Invalid username or password';
    }
  }

  void signupTraveler(String name, String email, String password) {
    final newUser = User(
      id: 'u${_users.length + 1}',
      name: name,
      email: email,
      password: password,
      role: UserRole.traveler,
    );
    _users.add(newUser);
    state = newUser;
  }

  void logout() {
    state = null;
  }
}

// Provider already defined at the top
