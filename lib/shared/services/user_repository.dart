import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';

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
