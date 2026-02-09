import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/auth_service.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;

  const AdminShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: Text('Overview'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Users'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.verified_outlined),
                  selectedIcon: Icon(Icons.verified),
                  label: Text('Services'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.attach_money),
                  selectedIcon: Icon(Icons.attach_money),
                  label: Text('Financials'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.support_agent),
                  selectedIcon: Icon(Icons.support_agent),
                  label: Text('Support'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white70),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  tooltip: 'Logout',
                ),
              ),
              selectedIndex: _calculateSelectedIndex(context),
              onDestinationSelected: (index) => _onItemTapped(index, context),
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
                  _buildDrawerItem(
                    context,
                    0,
                    'Overview',
                    Icons.analytics_outlined,
                  ),
                  _buildDrawerItem(context, 1, 'Users', Icons.people_outline),
                  _buildDrawerItem(
                    context,
                    2,
                    'Services',
                    Icons.verified_outlined,
                  ),
                  _buildDrawerItem(
                    context,
                    3,
                    'Financials',
                    Icons.attach_money,
                  ),
                  _buildDrawerItem(context, 4, 'Support', Icons.support_agent),
                  _buildDrawerItem(
                    context,
                    5,
                    'Settings',
                    Icons.settings_outlined,
                  ),
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

  Widget _buildDrawerItem(
    BuildContext context,
    int index,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      selected: _calculateSelectedIndex(context) == index,
      onTap: () {
        _onItemTapped(index, context);
        Navigator.pop(context);
      },
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
        break;
      case 1:
        context.go('/admin/users');
        break;
      case 2:
        context.go('/admin/services');
        break;
      case 3:
        context.go('/admin/financials');
        break;
      case 4:
        context.go('/admin/support');
        break;
      case 5:
        context.go('/admin/settings');
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/admin/dashboard')) return 0;
    if (location.startsWith('/admin/users')) return 1;
    if (location.startsWith('/admin/services')) return 2;
    if (location.startsWith('/admin/financials')) return 3;
    if (location.startsWith('/admin/support')) return 4;
    if (location.startsWith('/admin/settings')) return 5;
    return 0;
  }
}
