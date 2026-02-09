import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _maintenanceMode = false;
  bool _emailNotifications = true;
  double _platformFee = 10.0;
  final String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
        backgroundColor: AppColors.dark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('General Settings'),
          SwitchListTile(
            title: const Text('Maintenance Mode'),
            subtitle: const Text('Prevent users from making new bookings'),
            value: _maintenanceMode,
            onChanged: (val) => setState(() => _maintenanceMode = val),
            secondary: const Icon(Icons.warning_amber),
          ),
          SwitchListTile(
            title: const Text('System Email Notifications'),
            subtitle: const Text('Send automatic emails for system events'),
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
            secondary: const Icon(Icons.notifications_active),
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('Financial Configuration'),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('Platform Fee (%)'),
            subtitle: Text('Current fee: ${_platformFee.toStringAsFixed(1)}%'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeeDialog(),
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Base Currency'),
            subtitle: Text('Current: $_selectedCurrency'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('Security'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Admin Password Policy'),
            subtitle: const Text('Manage complexity requirements'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Session Timeout'),
            subtitle: const Text('Current: 30 minutes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('App Info'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0 (Build 124)'),
          ),
          const ListTile(
            leading: Icon(Icons.build_circle_outlined),
            title: Text('Environment'),
            subtitle: Text('Development / Sandbox'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showFeeDialog() {
    final controller = TextEditingController(text: _platformFee.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Platform Fee'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: '%'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newFee = double.tryParse(controller.text);
              if (newFee != null) {
                setState(() => _platformFee = newFee);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
