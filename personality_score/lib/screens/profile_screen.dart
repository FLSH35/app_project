import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/auth/auth_service.dart';

import '../main.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionnaireModel = Provider.of<QuestionnaireModel>(context);
    final user = Provider.of<AuthService>(context).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Text('Please sign in to see your profile.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'), // Placeholder image
            ),
            SizedBox(height: 20),
            Text(
              user.displayName ?? 'Anonymous User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('results')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var results = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      var result = results[index];
                      if (result.id == 'finalCharacter') {
                        return Card(
                          child: ListTile(
                            title: Text('Final Character'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Image.asset('assets/${result['finalCharacter']}',
                                    width: 100, height: 100),
                                SizedBox(height: 10),
                                Text(result['finalCharacterDescription']),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          child: ListTile(
                            title: Text('Set: ${result['set']}'),
                            subtitle: Text('Score: ${result['totalScore']}'),
                            trailing: result['isCompleted'] != null && result['isCompleted']
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.pending, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}