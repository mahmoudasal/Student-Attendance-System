import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/navbar.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for theme persistence
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Student Attendance System',

          // Theme Configuration with smooth transitions
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeProvider.themeMode,

          // Theme Animation Duration
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOut,

          // Routes
          initialRoute: "WelcomeScreen",
          routes: {
            "WelcomeScreen": (context) =>
                NavigatorScreen(themeProvider: _themeProvider),
            "Navpage": (context) =>
                NavigatorScreen(themeProvider: _themeProvider),
          },
        );
      },
    );
  }
}
