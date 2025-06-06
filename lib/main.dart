import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/detail_popular_movie.dart';
import 'package:tap2025/screens/favorites_screen.dart';
import 'package:tap2025/screens/popular_screen.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/utils/global_values.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mi App Flutter',
          themeMode: value == 1 ? ThemeMode.light : ThemeMode.dark,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
              case '/dashboard':
                return MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                );
              case '/popular':
                return MaterialPageRoute(
                  builder: (context) => const PopularScreen(),
                );
              case '/favorites':
                return MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                );
              case '/detail_popular_movie':
                final popularModel = settings.arguments as PopularModel;
                return MaterialPageRoute(
                  builder: (context) =>
                      DetailPopularMovie(movie: popularModel),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
            }
          },
        );
      },
    );
  }
}
