import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personality_score/screens/questionnaire_screen.dart';
import 'package:provider/provider.dart';
import 'auth/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'firebase_options.dart'; // Ensure you have this file generated
import 'package:personality_score/screens/profile_screen.dart';
import 'package:personality_score/models/questionaire_model.dart';
import 'package:personality_score/screens/personality_type_screen.dart'; // Import the new screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => QuestionnaireModel()),
      ],
      child: MaterialApp(
        title: 'Personality Score',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthService>(
            builder: (context, authService, child) {
              if (authService.user == null) {
                return SignInScreen();
              } else {
                return HomeScreen();
              }
            },
          ),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
          '/questionnaire': (context) => QuestionnaireScreen(),
          '/profile': (context) => ProfileScreen(),
          '/personality_types': (context) => PersonalityTypesPage(), // Add new route
        },
      ),
    );
  }
}
