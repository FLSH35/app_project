import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personality_score/screens/questionnaire_screen.dart';
import 'package:provider/provider.dart';
import 'auth/auth_service.dart';
import 'package:share_plus/share_plus.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'firebase_options.dart';
import 'screens/profile_screen.dart';
import 'package:personality_score/models/questionaire_model.dart';

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
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personality Score'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Check out my personality score!');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoSection(),
            StatsSection(),
            CallToActionSection(),
            PersonalityTypesSection(),
            TeamsSection(),
            TestimonialsSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

class LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add your logo here
          Image.asset('assets/logo.png'), // Ensure you have a logo image in assets
          Text(
            'It’s so incredible to finally be understood.',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/questionnaire');
            },
            child: Text('Take the Test'),
          ),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('276K+ Tests taken today', style: TextStyle(fontSize: 16)),
          Text('19M+ Tests taken in Germany', style: TextStyle(fontSize: 16)),
          Text('1229M+ Total tests taken', style: TextStyle(fontSize: 16)),
          Text('91.2% Results rated as accurate or very accurate', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class CallToActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset('assets/picnic.png'), // Add an image asset here
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/questionnaire');
            },
            child: Text('Take the Test'),
          ),
        ],
      ),
    );
  }
}

class PersonalityTypesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset('assets/discussion.png'), // Add an image asset here
          Text(
            'Understand others',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'In our free type descriptions you’ll learn what really drives, inspires, and worries different personality types, helping you build more meaningful relationships.',
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to Personality Types
            },
            child: Text('Personality Types'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to Explore Theory
            },
            child: Text('Explore Theory'),
          ),
        ],
      ),
    );
  }
}

class TeamsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset('assets/colleagues.png'), // Add an image asset here
          Text(
            'Understand your team better',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Understand your team better with our Team Assessments. Improve communication, create harmony, and help team members develop their individual strengths. Works for teams of all sizes.',
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to Team Assessments
            },
            child: Text('Team Assessments'),
          ),
        ],
      ),
    );
  }
}

class TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'See what others have to say',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Testimonial(
            name: 'Benny',
            type: 'ARCHITECT (INTJ-A)',
            feedback: 'Incredibly thorough and scary. It’s like someone putting a mirror to your face and you seeing your true self whether you like it or not.',
          ),
          Testimonial(
            name: 'Nicole',
            type: 'ADVOCATE (INFJ-T)',
            feedback: 'Wow! This site is just AMAZING! I took the test and the results were so spot on, I felt like I had been vindicated.',
          ),
          // Add more testimonials here
        ],
      ),
    );
  }
}

class Testimonial extends StatelessWidget {
  final String name;
  final String type;
  final String feedback;

  Testimonial({required this.name, required this.type, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(name),
        subtitle: Text('$type\n\n$feedback'),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Curious how accurate we are about you?'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/questionnaire');
            },
            child: Text('Take the Test'),
          ),
          // Add more footer links and details here
        ],
      ),
    );
  }
}

