import 'package:go_router/go_router.dart';

import '../features/authentication/screens/create_account_request_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/waiting_approval_screen.dart';
import '../features/beast/models/beast_type.dart';
import '../features/beast/screens/beast_priorities_screen.dart';
import '../features/beast/screens/beast_screen.dart';
import '../features/beast/screens/beast_skills_screen.dart';
import '../features/beast/screens/beast_skins_screen.dart';
import '../features/beast/screens/beast_talents_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/member_profile/screens/member_profile_screen.dart';
import '../features/members/screens/members_screen.dart';
import '../features/welcome/screens/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const WelcomeScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) {
        return const CreateAccountRequestScreen();
      },
    ),
    GoRoute(
      path: '/waiting-approval',
      builder: (context, state) {
        return const WaitingApprovalScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),
    GoRoute(
      path: '/members',
      builder: (context, state) {
        return const MembersScreen();
      },
    ),
    GoRoute(
      path: '/member/:amId',
      builder: (context, state) {
        final amId = state.pathParameters['amId']!;

        return MemberProfileScreen(amId: amId);
      },
    ),
    GoRoute(
      path: '/member/:amId/beast',
      builder: (context, state) {
        final amId = state.pathParameters['amId']!;

        return BeastScreen(amId: amId);
      },
    ),
    GoRoute(
      path: '/member/:amId/beast/skills',
      builder: (context, state) {
        final amId = state.pathParameters['amId']!;

        return BeastSkillsScreen(amId: amId);
      },
    ),
    GoRoute(
      path: '/member/:amId/beast/talents/:beastType',
      builder: (context, state) {
        final beastTypeName = state.pathParameters['beastType']!;

        final beastType = BeastType.values.firstWhere(
          (type) => type.name == beastTypeName,
          orElse: () => BeastType.panda,
        );

        return BeastTalentsScreen(beastType: beastType);
      },
    ),
    GoRoute(
      path: '/member/:amId/beast/skins',
      builder: (context, state) {
        final amId = state.pathParameters['amId']!;

        return BeastSkinsScreen(amId: amId);
      },
    ),
    GoRoute(
      path: '/admin/beast/priorities',
      builder: (context, state) {
        return const BeastPrioritiesScreen();
      },
    ),
  ],
);
