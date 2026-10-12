import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CodeAstraApp());
}

class CodeAstraApp extends StatelessWidget {
  const CodeAstraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeAstra',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3C3489),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Ito ang "gatekeeper" ng app — nakikinig sa login state gamit ang
/// authStateChanges stream ng Firebase. Kung naka-login na ang user,
/// diretso sa HomeScreen (na may bottom nav); kung hindi, LoginScreen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
