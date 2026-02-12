import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;

  const AdminShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final adminRole = user?.adminRole ?? AdminRole.supportAdmin;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final navItems = _getNavItems(adminRole);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              backgroundColor: AppColors.dark,
              unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              selectedIconTheme: const IconThemeData(color: AppColors.accent),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
              leading: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.accent,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      adminRole.name.toUpperCase().replaceAll('ADMIN', ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(fontSize: 10, color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              destinations: navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white70),
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                    ),
                  ),
                ),
              ),
              selectedIndex: _calculateSelectedIndex(context, navItems),
              onDestinationSelected: (index) =>
                  _onItemTapped(index, context, navItems),
            ),
            Expanded(
              child: Column(
                children: [
                  // Desktop Top Bar
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          _getPageTitle(context),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () => context.go('/admin/profile'),
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.primary,
                                  backgroundImage: user?.profileImage != null
                                      ? NetworkImage(user!.profileImage!)
                                      : null,
                                  child: user?.profileImage == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.name ?? 'Admin',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      adminRole.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
        backgroundColor: AppColors.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => context.go('/admin/profile'),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.dark,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.accent,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Admin Portal",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ...navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      leading: Icon(item.icon, color: Colors.white70),
                      title: Text(
                        item.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                      selected:
                          _calculateSelectedIndex(context, navItems) == index,
                      onTap: () {
                        _onItemTapped(index, context, navItems);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: child,
    );
  }

  void _onItemTapped(int index, BuildContext context, List<_NavItem> navItems) {
    context.go(navItems[index].route);
  }

  int _calculateSelectedIndex(BuildContext context, List<_NavItem> navItems) {
    final String location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < navItems.length; i++) {
      if (location.startsWith(navItems[i].route)) return i;
    }
    return 0;
  }

  List<_NavItem> _getNavItems(AdminRole role) {
    final allItems = [
      _NavItem(
        label: 'Overview',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        route: '/admin/dashboard',
        roles: [
          AdminRole.superAdmin,
          AdminRole.opsAdmin,
          AdminRole.financeAdmin,
          AdminRole.supportAdmin,
        ],
      ),
      _NavItem(
        label: 'Users',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        route: '/admin/users',
        roles: [AdminRole.superAdmin, AdminRole.opsAdmin],
      ),
      _NavItem(
        label: 'Services',
        icon: Icons.verified_outlined,
        selectedIcon: Icons.verified,
        route: '/admin/services',
        roles: [
          AdminRole.superAdmin,
          AdminRole.supportAdmin,
          AdminRole.opsAdmin,
        ],
      ),
      _NavItem(
        label: 'Financials',
        icon: Icons.attach_money,
        selectedIcon: Icons.attach_money,
        route: '/admin/financials',
        roles: [AdminRole.superAdmin, AdminRole.financeAdmin],
      ),
      _NavItem(
        label: 'Support',
        icon: Icons.support_agent,
        selectedIcon: Icons.support_agent,
        route: '/admin/support',
        roles: [
          AdminRole.superAdmin,
          AdminRole.supportAdmin,
          AdminRole.opsAdmin,
        ],
      ),
      _NavItem(
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: '/admin/settings',
        roles: [AdminRole.superAdmin],
      ),
      _NavItem(
        label: 'Banners',
        icon: Icons.image_outlined,
        selectedIcon: Icons.image,
        route: '/admin/banners',
        roles: [AdminRole.superAdmin, AdminRole.opsAdmin],
      ),
    ];

    return allItems.where((item) => item.roles.contains(role)).toList();
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final List<AdminRole> roles;

  _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    required this.roles,
  });
}

String _getPageTitle(BuildContext context) {
  final location = GoRouterState.of(context).uri.path;
  if (location.contains('dashboard')) return 'Dashboard';
  if (location.contains('users')) return 'User Management';
  if (location.contains('services')) return 'Service Listings';
  if (location.contains('financials')) return 'Financial Reports';
  if (location.contains('support')) return 'Support Center';
  if (location.contains('settings')) return 'System Settings';
  if (location.contains('banners')) return 'Banner Management';
  return 'Admin Portal';
}
