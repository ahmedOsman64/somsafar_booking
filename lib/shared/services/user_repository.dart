import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';
import 'auth_service.dart';

class UserRepository extends StateNotifier<List<User>> {
  UserRepository()
    : super([
        MockData().travelerUser,
        MockData().providerUser,
        MockData().adminUser,
        MockData().travelerAhmed,
        MockData().providerAsha,
        MockData().travelerDeeqa,
        MockData().providerLiban,
      ]);

  void addUser(User user) {
    state = [...state, user];
  }

  void updateUser(User updatedUser) {
    state = [
      for (final u in state)
        if (u.id == updatedUser.id) updatedUser else u,
    ];
  }

  void deleteUser(String id) {
    state = state.where((u) => u.id != id).toList();
  }

  int get totalUsers => state.length;
  int get providerCount =>
      state.where((u) => u.role == UserRole.provider).length;
}

final userProvider = StateNotifierProvider<UserRepository, List<User>>((ref) {
  return UserRepository();
});

// Selector for role-based data isolation
final filteredUsersProvider = Provider<List<User>>((ref) {
  final user = ref.watch(authProvider);
  final users = ref.watch(userProvider);

  if (user == null) return [];

  switch (user.role) {
    case UserRole.traveler:
      // Travelers can only see their own profile
      return users.where((u) => u.id == user.id).toList();
    case UserRole.provider:
      // Providers generally shouldn't see all users, but maybe travelers who booked?
      // For now, keep it strict: only themselves
      return users.where((u) => u.id == user.id).toList();
    case UserRole.admin:
      // Admins see everyone
      return users;
  }
});
