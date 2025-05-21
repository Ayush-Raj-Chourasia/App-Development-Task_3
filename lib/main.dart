import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A73E8), // Custom blue
      brightness: Brightness.light,
    );
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        title: 'Movie Explorer',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            bodyMedium: TextStyle(fontSize: 16),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            centerTitle: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
