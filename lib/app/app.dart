import 'package:flutter/material.dart';

import '../navigation/app_router.dart';
import '../theme/am_theme.dart';

class AllianceManagerApp extends StatelessWidget {
  const AllianceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alliance Manager',
      debugShowCheckedModeBanner: false,
      theme: AMTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}