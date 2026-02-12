import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/login_screen.dart';
import '../../auth/signup_screen.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';
import '../../traveler/widgets/traveler_shell.dart';
import '../../provider/widgets/provider_shell.dart';
import '../../admin/widgets/admin_shell.dart';
import '../../auth/forgot_password_screen.dart';
import '../../auth/verification_screen.dart';
import '../../auth/reset_password_screen.dart';

// Screens
import '../../traveler/screens/home_screen.dart';
import '../../traveler/screens/search_screen.dart';
import '../../traveler/screens/bookings_screen.dart';
import '../../traveler/screens/profile_screen.dart';
import '../../traveler/screens/service_details_screen.dart';

import '../../provider/screens/provider_screens.dart'; // Dashboard
import '../../provider/screens/services_list_screen.dart';
import '../../provider/screens/bookings_screen.dart';

import '../../admin/screens/dashboard_screen.dart';
import '../../admin/screens/users_screen.dart';
import '../../admin/screens/services_screen.dart';
import '../../admin/screens/financials_screen.dart';
import '../../admin/screens/support_screen.dart';
import '../../admin/screens/settings_screen.dart';
import '../../admin/screens/create_user_screen.dart';
import '../../admin/screens/admin_profile_screen.dart';
import '../../admin/screens/admin_banner_manager_screen.dart';

import '../../provider/screens/provider_service_form_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      // Paths that should be accessible without authentication
      final publicPaths = {
        '/login',
        '/signup',
        '/forgot-password',
        '/verify-email',
        '/reset-password',
      };

      final isPublic = publicPaths.contains(state.uri.path);

      if (!isLoggedIn) {
        return isPublic ? null : '/login';
      }

      // If logged in and trying to go to login or signup, redirect to role home
      final authEntryPaths = {'/login', '/signup'};
      final isAuthEntry = authEntryPaths.contains(state.uri.path);
      if (isAuthEntry) {
        switch (authState.role) {
          case UserRole.traveler:
            return '/traveler/home';
          case UserRole.provider:
            return '/provider/dashboard';
          case UserRole.admin:
            return '/admin/dashboard';
        }
      }

      final path = state.uri.path;

      // Strict Role Guards & Hierarchy
      if (authState.role == UserRole.traveler) {
        if (path.startsWith('/provider') || path.startsWith('/admin')) {
          return '/access-denied';
        }
      } else if (authState.role == UserRole.provider) {
        if (path.startsWith('/traveler') || path.startsWith('/admin')) {
          return '/access-denied';
        }
      } else if (authState.role == UserRole.admin) {
        // Admin sub-role granular access
        final adminRole = authState.adminRole;
        if (adminRole == null) return '/access-denied';

        if (adminRole == AdminRole.opsAdmin) {
          if (path.startsWith('/admin/financials') ||
              path.startsWith('/admin/settings')) {
            return '/access-denied';
          }
        } else if (adminRole == AdminRole.financeAdmin) {
          if (path.startsWith('/admin/users') ||
              path.startsWith('/admin/services') ||
              path.startsWith('/admin/support') ||
              path.startsWith('/admin/settings')) {
            return '/access-denied';
          }
        } else if (adminRole == AdminRole.supportAdmin) {
          if (path.startsWith('/admin/users') ||
              path.startsWith('/admin/financials') ||
              path.startsWith('/admin/settings')) {
            return '/access-denied';
          }
        }
        // Super Admin has full access
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/access-denied',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_person_outlined,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  '❌ Access Denied',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('You do not have permission to access this page.'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    final auth = ref.read(authProvider);
                    if (auth == null) {
                      context.go('/login');
                    } else {
                      switch (auth.role) {
                        case UserRole.traveler:
                          context.go('/traveler/home');
                          break;
                        case UserRole.provider:
                          context.go('/provider/dashboard');
                          break;
                        case UserRole.admin:
                          context.go('/admin/dashboard');
                          break;
                      }
                    }
                  },
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) =>
            VerificationScreen(email: state.extra as String),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) =>
            ResetPasswordScreen(email: state.extra as String),
      ),

      // Traveler Routes
      ShellRoute(
        builder: (context, state, child) => TravelerShell(child: child),
        routes: [
          GoRoute(
            path: '/traveler/home',
            builder: (context, state) => const TravelerHomeScreen(),
          ),
          GoRoute(
            path: '/traveler/search',
            builder: (context, state) => const TravelerSearchScreen(),
          ),
          GoRoute(
            path: '/traveler/bookings',
            builder: (context, state) => const TravelerBookingsScreen(),
          ),
          GoRoute(
            path: '/traveler/profile',
            builder: (context, state) => const TravelerProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/traveler/service/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ServiceDetailsScreen(serviceId: state.pathParameters['id']!),
      ),

      // Provider Routes
      ShellRoute(
        builder: (context, state, child) => ProviderShell(child: child),
        routes: [
          GoRoute(
            path: '/provider/dashboard',
            builder: (context, state) => const ProviderDashboardScreen(),
          ),
          GoRoute(
            path: '/provider/services',
            builder: (context, state) => const ProviderServicesScreen(),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey, // Show over shell
                builder: (context, state) => const ProviderServiceFormScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ProviderServiceFormScreen(
                  serviceId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/provider/bookings',
            builder: (context, state) => const ProviderBookingsScreen(),
          ),
        ],
      ),

      // Admin Routes
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const AdminUsersScreen(),
            routes: [
              GoRoute(
                path: 'create',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final role = state.uri.queryParameters['role'];
                  return AdminCreateProviderScreen(initialRole: role);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/admin/services',
            builder: (context, state) => const AdminServicesScreen(),
          ),
          GoRoute(
            path: '/admin/financials',
            builder: (context, state) => const AdminFinancialsScreen(),
          ),
          GoRoute(
            path: '/admin/support',
            builder: (context, state) => const AdminSupportScreen(),
          ),
          GoRoute(
            path: '/admin/settings',
            builder: (context, state) => const AdminSettingsScreen(),
          ),
          GoRoute(
            path: '/admin/profile',
            builder: (context, state) => const AdminProfileScreen(),
          ),
          GoRoute(
            path: '/admin/banners',
            builder: (context, state) => const AdminBannerManagerScreen(),
          ),
        ],
      ),
    ],
  );
});
