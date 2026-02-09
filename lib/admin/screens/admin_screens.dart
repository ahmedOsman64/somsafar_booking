import 'package:flutter/material.dart';
import '../../core/widgets/placeholder_screen.dart';
import '../admin_strings.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(AdminStrings.titleDashboard);
}

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(AdminStrings.manageUsers);
}

class AdminServicesScreen extends StatelessWidget {
  const AdminServicesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(AdminStrings.manageServices);
}

class AdminFinancialsScreen extends StatelessWidget {
  const AdminFinancialsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(AdminStrings.financialReports);
}
