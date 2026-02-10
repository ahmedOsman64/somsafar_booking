import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/user_repository.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _filter = 'all'; // all, traveler, provider, admin

  List<User> get _filteredUsers {
    final users = ref.watch(filteredUsersProvider);
    if (_filter == 'all') return users;
    if (_filter == 'traveler') {
      return users.where((u) => u.role == UserRole.traveler).toList();
    }
    if (_filter == 'provider') {
      return users.where((u) => u.role == UserRole.provider).toList();
    }
    if (_filter == 'admin') {
      return users.where((u) => u.role == UserRole.admin).toList();
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (role) {
              context.go('/admin/users/create?role=$role');
            },
            icon: const Icon(Icons.person_add),
            tooltip: 'Create New Account',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Provider',
                child: Row(
                  children: [
                    Icon(Icons.store, color: AppColors.primary),
                    SizedBox(width: 12),
                    Text('Create Provider'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: AppColors.primary),
                    SizedBox(width: 12),
                    Text('Create Admin'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All Users',
                  isSelected: _filter == 'all',
                  onSelected: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Travelers',
                  isSelected: _filter == 'traveler',
                  onSelected: () => setState(() => _filter = 'traveler'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Providers',
                  isSelected: _filter == 'provider',
                  onSelected: () => setState(() => _filter = 'provider'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Admins',
                  isSelected: _filter == 'admin',
                  onSelected: () => setState(() => _filter = 'admin'),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                final isProvider = user.role == UserRole.provider;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: user.status == UserStatus.blocked
                              ? Colors.grey
                              : isProvider
                              ? Colors.teal
                              : Colors.blue,
                          child: Icon(
                            isProvider ? Icons.store : Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        if (isProvider && user.name.startsWith('Verified'))
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        decoration: user.status == UserStatus.blocked
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.email} • ${user.role.name.toUpperCase()}'),
                        if (isProvider && !user.name.startsWith('Verified'))
                          const Text(
                            'Status: Pending Verification',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'toggle_block') {
                          final newStatus = user.status == UserStatus.blocked
                              ? UserStatus.active
                              : UserStatus.blocked;
                          ref
                              .read(userProvider.notifier)
                              .updateUser(user.copyWith(status: newStatus));
                        } else if (value == 'verify') {
                          ref
                              .read(userProvider.notifier)
                              .updateUser(
                                user.copyWith(name: 'Verified ${user.name}'),
                              );
                        } else if (value == 'delete') {
                          ref.read(userProvider.notifier).deleteUser(user.id);
                        }
                      },
                      itemBuilder: (context) => [
                        if (isProvider && !user.name.startsWith('Verified'))
                          const PopupMenuItem(
                            value: 'verify',
                            child: Text('Verify Identity'),
                          ),

                        PopupMenuItem(
                          value: 'toggle_block',
                          child: Text(
                            user.status == UserStatus.blocked
                                ? 'Unblock User'
                                : 'Block User',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete User',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withAlpha(51),
      checkmarkColor: AppColors.primary,
    );
  }
}
