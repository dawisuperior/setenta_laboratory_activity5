import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/student_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StudentLocalDbApp());
}

class StudentLocalDbApp extends StatelessWidget {
  const StudentLocalDbApp({super.key});

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Local DB App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Exclusive Dark Theme
      themeMode: ThemeMode.dark,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? const StudentScreen() : const LoginScreen();
          }
        },
      ),
    );
  }
}
