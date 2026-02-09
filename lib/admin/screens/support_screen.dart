import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AdminSupportScreen extends StatefulWidget {
  const AdminSupportScreen({super.key});

  @override
  State<AdminSupportScreen> createState() => _AdminSupportScreenState();
}

class _AdminSupportScreenState extends State<AdminSupportScreen> {
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-101',
      'user': 'Ahmed Hassan',
      'subject': 'Payment Issue',
      'status': 'Open',
      'priority': 'High',
      'date': '2024-03-20',
      'message': 'My payment was deducted twice for the booking.',
    },
    {
      'id': 'TKT-102',
      'user': 'Sarah Jones',
      'subject': 'Login Problem',
      'status': 'In Progress',
      'priority': 'Medium',
      'date': '2024-03-19',
      'message': 'I cannot reset my password.',
    },
    {
      'id': 'TKT-103',
      'user': 'Mike Ross',
      'subject': 'Booking Cancellation',
      'status': 'Closed',
      'priority': 'Low',
      'date': '2024-03-18',
      'message': 'I want to cancel my booking for the beach villa.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTickets = _filterStatus == 'All'
        ? _tickets
        : _tickets.where((t) => t['status'] == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        backgroundColor: AppColors.dark,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: filteredTickets.isEmpty
                ? const Center(child: Text('No tickets found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = filteredTickets[index];
                      return _buildTicketCard(ticket);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['All', 'Open', 'In Progress', 'Closed'].map((status) {
          final isSelected = _filterStatus == status;
          return FilterChip(
            label: Text(status),
            selected: isSelected,
            onSelected: (val) {
              setState(() => _filterStatus = status);
            },
            selectedColor: AppColors.primary.withAlpha(26),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(ticket['priority']).withAlpha(26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ticket['priority'],
                style: TextStyle(
                  color: _getPriorityColor(ticket['priority']),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(ticket['subject']),
          ],
        ),
        subtitle: Text('${ticket['id']} • ${ticket['user']}'),
        trailing: _buildStatusBadge(ticket['status']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(ticket['message']),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Transfer'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Reply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Open':
        color = Colors.red;
        break;
      case 'In Progress':
        color = Colors.orange;
        break;
      case 'Closed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
