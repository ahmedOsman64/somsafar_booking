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
              destinations: navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white70),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ),
              selectedIndex: _calculateSelectedIndex(context, navItems),
              onDestinationSelected: (index) =>
                  _onItemTapped(index, context, navItems),
            ),
            Expanded(child: child),
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
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 20, color: Colors.white),
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
