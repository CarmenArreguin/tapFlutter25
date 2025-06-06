import 'package:flutter/material.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/favorites_screen.dart';
import 'package:tap2025/screens/popular_screen.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/screens/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/login': (context) => const LoginScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/popular': (context) => const PopularScreen(),
  '/favorites': (context) => const FavoritesScreen(),
  '/profile': (context) => const ProfileScreen(),
};
