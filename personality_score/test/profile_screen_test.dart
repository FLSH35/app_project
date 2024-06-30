import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/auth/auth_service.dart';
import 'package:personality_score/screens/home_screen.dart';

// Custom MockAuthService
class MockAuthService extends ChangeNotifier implements AuthService {
  bool signedOut = false;

  @override
  Future<void> signOut() async {
    signedOut = true;
    notifyListeners();
  }

  @override
  // TODO: implement errorMessage
  String? get errorMessage => null;

  @override
  Future<void> signInWithEmail(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUpWithEmail(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDisplayName(String displayName) {
    throw UnimplementedError();
  }

  @override
  User? get user => null;
}

void main() {
  testWidgets('Home Screen displays correct information and buttons work', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
        ],
        child: MaterialApp(
          home: HomeScreen(),
          routes: {
            '/signin': (context) => Scaffold(body: Text('Sign In Screen')),
            '/profile': (context) => Scaffold(body: Text('Profile Screen')),
            '/questionnaire': (context) => Scaffold(body: Text('Questionnaire Screen')),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the home screen text is displayed
    expect(find.text("It's so incredible to finally be understood."), findsOneWidget);
    expect(find.text("Only 10 minutes to get a 'freakishly accurate' description of who you are and why you do things the way you do."), findsOneWidget);

    // Verify that the statistics are displayed
    expect(find.text('1M+'), findsOneWidget);
    expect(find.text('Tests taken today'), findsOneWidget);
    expect(find.text('19M+'), findsOneWidget);
    expect(find.text('Tests taken in Germany'), findsOneWidget);
    expect(find.text('1204M+'), findsOneWidget);
    expect(find.text('Total tests taken'), findsOneWidget);
    expect(find.text('91.2%'), findsOneWidget);
    expect(find.text('Results rated as accurate or very accurate'), findsOneWidget);

    // Debug print for icon search
    print('Searching for logout icon...');
    final logoutIconFinder = find.byIcon(Icons.logout);
    expect(logoutIconFinder, findsOneWidget);

    // Verify the buttons and their actions
    await tester.tap(logoutIconFinder);
    await tester.pumpAndSettle();
    expect(mockAuthService.signedOut, true);
    expect(find.text('Sign In Screen'), findsOneWidget);

    print('Searching for person icon...');
    final personIconFinder = find.byIcon(Icons.person);
    expect(personIconFinder, findsOneWidget);

    await tester.tap(personIconFinder);
    await tester.pumpAndSettle();
    expect(find.text('Profile Screen'), findsOneWidget);

    await tester.tap(find.text('Take the Test'));
    await tester.pumpAndSettle();
    expect(find.text('Questionnaire Screen'), findsOneWidget);
  });
}
