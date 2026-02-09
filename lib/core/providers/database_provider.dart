import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

// Provider for DatabaseService
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
