import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';

class ProviderShell extends ConsumerWidget {
  final Widget child;

  const ProviderShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final user = ref.watch(authProvider);
    final providerType = user?.providerType ?? ProviderType.hotel;

    String servicesLabel = 'Services';
    String bookingsLabel = 'Bookings';
    IconData servicesIcon = Icons.list_alt;
    IconData bookingsIcon = Icons.book_online;

    switch (providerType) {
      case ProviderType.hotel:
        servicesLabel = 'Hotels';
        bookingsLabel = 'Room Bookings';
        servicesIcon = Icons.hotel;
        break;
      case ProviderType.home:
        servicesLabel = 'Homes';
        bookingsLabel = 'Home Bookings';
        servicesIcon = Icons.home;
        break;
      case ProviderType.apartment:
        servicesLabel = 'Apartments';
        bookingsLabel = 'Apartment Bookings';
        servicesIcon = Icons.apartment;
        break;
      case ProviderType.transport:
        servicesLabel = 'Vehicles';
        bookingsLabel = 'Vehicle Rentals';
        servicesIcon = Icons.directions_car;
        break;
    }

    if (isDesktop) {
      // Desktop Sidebar Layout
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              backgroundColor: Colors.white,
              selectedIconTheme: const IconThemeData(
                color: AppColors.secondary,
              ),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(servicesIcon),
                  selectedIcon: Icon(servicesIcon),
                  label: Text(servicesLabel),
                ),
                NavigationRailDestination(
                  icon: Icon(bookingsIcon),
                  selectedIcon: Icon(bookingsIcon),
                  label: Text(bookingsLabel),
                ),
              ],
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: const Icon(Icons.logout),
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
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Mobile/Tablet Drawer Layout
    return Scaffold(
      appBar: AppBar(
        title: Text(
          servicesLabel.isNotEmpty
              ? '${servicesLabel.substring(0, servicesLabel.length - 1)} Console'
              : 'Console',
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: AppColors.primary),
                    accountName: Text(user?.name ?? "Provider"),
                    accountEmail: Text(user?.email ?? "provider@somsafar.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: user?.profileImage != null
                          ? NetworkImage(user!.profileImage!)
                          : null,
                      child: user?.profileImage == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined),
                    title: const Text('Dashboard'),
                    selected: _calculateSelectedIndex(context) == 0,
                    onTap: () {
                      _onItemTapped(0, context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(servicesIcon),
                    title: Text(servicesLabel),
                    selected: _calculateSelectedIndex(context) == 1,
                    onTap: () {
                      _onItemTapped(1, context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(bookingsIcon),
                    title: Text(bookingsLabel),
                    selected: _calculateSelectedIndex(context) == 2,
                    onTap: () {
                      _onItemTapped(2, context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
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

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/provider/dashboard');
        break;
      case 1:
        context.go('/provider/services');
        break;
      case 2:
        context.go('/provider/bookings');
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/provider/dashboard')) return 0;
    if (location.startsWith('/provider/services')) return 1;
    if (location.startsWith('/provider/bookings')) return 2;
    return 0;
  }
}
