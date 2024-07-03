import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personality Test'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final authService = Provider.of<AuthService>(context, listen: false);
              await authService.signOut();
              Navigator.of(context).pushReplacementNamed('/signin');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "It's so incredible to finally be understood.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Only 10 minutes to get a 'freakishly accurate' description of who you are and why you do things the way you do.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/questionnaire');
            },
            child: Text('Take the Test'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Image.asset('assets/home_illustration.webp'), // Use the WebP illustration
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatistic('0M+', 'Tests taken today'),
                _buildStatistic('0M+', 'Tests taken in Germany'),
                _buildStatistic('1+', 'Total tests taken'),
                _buildStatistic('100%', 'Results rated as accurate or very accurate'),
              ].map((widget) => Expanded(child: widget)).toList(), // Wrap each child in Expanded
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String value, String description) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(description, textAlign: TextAlign.center),
      ],
    );
  }
}