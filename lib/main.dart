import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/habits.dart';
import 'screens/add_habit_form.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/aboutPage.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialisation de Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Supprime le bandeau "Debug"
      initialRoute: '/login', // Route initiale est le login
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const HomePage(),
        '/habits': (context) => const HabitsPage(),
        '/add-habit': (context) => const AddHabitForm(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const Settings(),
        '/about': (context) => const AboutPage(),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF624E88),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF624E88),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Couleur du texte des boutons
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCB80AB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
