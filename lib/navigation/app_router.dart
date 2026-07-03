import 'package:go_router/go_router.dart';

import '../features/welcome/screens/welcome_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/create_account_request_screen.dart';
import '../features/authentication/screens/waiting_approval_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountRequestScreen(),
    ),
    GoRoute(
      path: '/waiting-approval',
      builder: (context, state) => const WaitingApprovalScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);