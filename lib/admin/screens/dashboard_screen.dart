import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../admin_strings.dart';
import '../../shared/services/service_repository.dart';
import '../../shared/services/booking_repository.dart';
import '../../shared/services/user_repository.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/booking_model.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider);
    final bookings = ref.watch(bookingProvider);
    final users = ref.watch(userProvider);

    // Admin KPIs
    final totalUsers = users.length;
    final totalProviders = users
        .where((u) => u.role == UserRole.provider)
        .length;
    final totalServices = services.length;
    final pendingServices = services
        .where((s) => s.status == ServiceStatus.pendingApproval)
        .length;
    final totalBookings = bookings.length;
    final totalRevenue = bookings
        .where((b) => b.status == BookingStatus.completed)
        .fold(0.0, (sum, b) {
          final service = services.firstWhere(
            (s) => s.id == b.serviceId,
            orElse: () => services.first,
          );
          return sum + service.price;
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AdminStrings.titleDashboard),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Health Monitor
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _SystemHealthBar(),
            ),
            const SizedBox(height: 24),

            Text(
              AdminStrings.platformOverview,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Responsive grid for KPI cards. Use a taller childAspectRatio
            // on narrow layouts to avoid bottom overflow when the card's
            // internal content needs more vertical space.
            Builder(
              builder: (context) {
                final width = MediaQuery.of(context).size.width;
                final crossAxisCount = width > 1200
                    ? 6
                    : width > 800
                    ? 3
                    : 2;
                // Decrease aspect ratio (more height) to prevent overflow.
                final childAspectRatio = width > 1200
                    ? 0.85
                    : width > 800
                    ? 0.8
                    : 0.95;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _AdminKpiCard(
                      title: AdminStrings.totalUsers,
                      value: totalUsers.toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    _AdminKpiCard(
                      title: AdminStrings.providers,
                      value: totalProviders.toString(),
                      icon: Icons.store,
                      color: Colors.teal,
                    ),
                    _AdminKpiCard(
                      title: AdminStrings.activeServices,
                      value: totalServices.toString(),
                      icon: Icons.hotel,
                      color: Colors.orange,
                    ),
                    _AdminKpiCard(
                      title: AdminStrings.pendingApprovals,
                      value: pendingServices.toString(),
                      icon: Icons.verified,
                      color: pendingServices > 0 ? Colors.red : Colors.green,
                    ),
                    _AdminKpiCard(
                      title: AdminStrings.totalBookings,
                      value: totalBookings.toString(),
                      icon: Icons.book_online,
                      color: Colors.purple,
                    ),
                    _AdminKpiCard(
                      title: AdminStrings.revenue,
                      value: '\$${totalRevenue.toStringAsFixed(0)}',
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AdminStrings.recentActivity,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '${AdminStrings.newProviderTitle} Hassan Ahmed',
                          ),
                          subtitle: const Text('Registered 5 mins ago'),
                          trailing: Chip(
                            label: const Text(AdminStrings.pendingVerify),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.add_business,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '${AdminStrings.newServiceTitle} Seaview Hotel',
                          ),
                          subtitle: const Text('Submitted for approval'),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: const Text(AdminStrings.review),
                          ),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.warning, color: Colors.white),
                          ),
                          title: Text('High Cancellation Rate'),
                          subtitle: Text(
                            'Provider #1234 has 5 cancellations today',
                          ),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.of(context).size.width > 800) ...[
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AdminStrings.systemAlerts,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withAlpha((0.3 * 255).round()),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                AdminStrings.databaseLatency,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'High response time detected in Booking Service.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text(AdminStrings.viewLogs),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemHealthBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.monitor_heart, color: Colors.green),
          const SizedBox(width: 8),
          const Text(
            'System Status: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Healthy',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 32),
          _HealthIndicator(label: 'API', isHealthy: true),
          const SizedBox(width: 16),
          _HealthIndicator(label: 'DB', isHealthy: true),
          const SizedBox(width: 16),
          _HealthIndicator(label: 'Payments', isHealthy: true),
        ],
      ),
    );
  }
}

class _HealthIndicator extends StatelessWidget {
  final String label;
  final bool isHealthy;
  const _HealthIndicator({required this.label, required this.isHealthy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isHealthy ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _AdminKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminKpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).round()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
