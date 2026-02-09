import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/user_repository.dart';

final forgotPasswordProvider = Provider((ref) => ForgotPasswordService(ref));

class ForgotPasswordService {
  final Ref _ref;
  // In-memory OTP storage: email -> otp
  static final Map<String, String> _otpStorage = {};

  ForgotPasswordService(this._ref);

  List<User> get _users => _ref.read(userProvider);

  Future<void> sendOtp(String email) async {
    try {
      // 1. Check if user exists
      final userExists = _users.any((u) => u.email == email);
      if (!userExists) {
        // For security, we might not want to reveal if email exists, 
        // but for UX in this app, we will throw error.
        throw Exception('Email address not found.');
      }

      // 2. Generate OTP
      final otp = (100000 + Random().nextInt(900000)).toString();

      // 3. Store OTP
      _otpStorage[email] = otp;

      // 4. Send Email (Mock)
      // In a real app, use mailer package here.
      debugPrint('----------------------------------------');
      debugPrint('🔐 RESET PASSWORD OTP for $email: $otp');
      debugPrint('----------------------------------------');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final storedOtp = _otpStorage[email];
    
    if (storedOtp == null) {
       throw Exception('OTP expired or not sent.');
    }
    
    if (storedOtp != otp) {
      throw Exception('Invalid OTP Code.');
    }
  }

  Future<void> updatePassword(String email, String newPassword) async {
      await Future.delayed(const Duration(seconds: 1));
      final userRepo = _ref.read(userProvider.notifier);
      final users = _ref.read(userProvider);
      
      try {
        final user = users.firstWhere(
          (u) => u.email == email, 
          orElse: () => throw Exception('User not found'),
        );
        
        final updatedUser = user.copyWith(password: newPassword);
        userRepo.updateUser(updatedUser);
        
        debugPrint('✅ Password updated for $email');
        
        _otpStorage.remove(email);
      } catch (e) {
        rethrow;
      }
  }
}
