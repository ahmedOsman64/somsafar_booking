import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/financial_model.dart';

// Mock Provider for now - Connect to Firestore later
final financialProvider = FutureProvider<FinancialData>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  return FinancialData(
    metrics: const FinancialMetrics(
      totalRevenue: 124500.0,
      platformFees: 12450.0, // 10%
      pendingPayouts: 8200.0,
      weeklyRevenue: [4000.0, 6000.0, 8000.0, 5000.0, 9000.0, 7000.0, 8500.0],
    ),
    transactions: [
      Transaction(
        id: 'TX1024',
        userName: 'Ahmed Hassan',
        amount: 450.0,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Transaction(
        id: 'TX1025',
        userName: 'Sarah Jones',
        amount: 1200.0,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'TX1026',
        userName: 'Mike Ross',
        amount: 300.0,
        status: 'Pending',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'TX1027',
        userName: 'James Wilson',
        amount: 850.0,
        status: 'Refunded',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 'TX1028',
        userName: 'Fatima Ali',
        amount: 150.0,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
  );
});

class FinancialData {
  final FinancialMetrics metrics;
  final List<Transaction> transactions;

  const FinancialData({required this.metrics, required this.transactions});
}
