import 'package:flutter/material.dart';

class AMNavigationDestination {
  const AMNavigationDestination({
    required this.title,
    required this.icon,
    required this.route,
    this.isAvailable = true,
    this.isAdministration = false,
  });

  final String title;
  final IconData icon;
  final String route;

  final bool isAvailable;
  final bool isAdministration;
}
