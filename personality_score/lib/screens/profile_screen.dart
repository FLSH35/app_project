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

    final personalityType = questionnaireModel.personalityType;
    final characterDescription = _getPersonalityDescription(personalityType, questionnaireModel.totalScore);

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
            if (personalityType != null) ...[
              Text(
                'Your Personality Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Image.asset('assets/$personalityType.webp'), // Use WebP format
              SizedBox(height: 10),
              Text(
                characterDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPersonalityDescription(String? type, int score) {
    if (type == null) return 'No description available.';

    int possibleScore = 120; // Adjust this to match your scoring logic
    bool isHighScore = score > (possibleScore * 0.5);

    switch (type) {
      case 'Individual':
        return isHighScore
            ? """Der Individual strebt nach Klarheit und Verwirklichung seiner Ziele, beeindruckt durch Selbstbewusstsein und klare Entscheidungen. Er inspiriert andere durch seine Entschlossenheit und positive Ausstrahlung."""
            : """Als ständiger Abenteurer strebt der Traveller nach neuen Erfahrungen und persönlichem Wachstum, stets begleitet von Neugier und Offenheit. Er inspiriert durch seine Entschlossenheit, das Leben in vollen Zügen zu genießen und sich kontinuierlich weiterzuentwickeln.""";
      case 'Reacher':
        return isHighScore
            ? """Als Initiator der Veränderung strebt der Reacher nach Wissen und persönlicher Entwicklung, trotz der Herausforderungen und Unsicherheiten. Seine Motivation und innere Stärke führen ihn auf den Weg des persönlichen Wachstums."""
            : """Immer offen für neue Wege der Entwicklung, erforscht der Explorer das Unbekannte und gestaltet sein Leben aktiv. Seine Offenheit und Entschlossenheit führen ihn zu neuen Ideen und persönlichem Wachstum.""";
      case 'Resident':
        return isHighScore
            ? """Der Anonymous operiert im Verborgenen, mit einem tiefen Weitblick und unaufhaltsamer Ruhe, beeinflusst er subtil aus dem Schatten. Sein unsichtbares Netzwerk und seine Anpassungsfähigkeit machen ihn zum verlässlichen Berater derjenigen im Rampenlicht."""
            : """Im ständigen Kampf mit inneren Dämonen sucht der Resident nach persönlichem Wachstum und Klarheit, unterstützt andere trotz eigener Herausforderungen. Seine Erfahrungen und Wissen bieten Orientierung, während er nach Selbstvertrauen und Stabilität strebt.""";
      case 'Life Artist':
        return isHighScore
            ? """Der Life Artist lebt seine Vision des Lebens mit Dankbarkeit und Energie, verwandelt Schwierigkeiten in bedeutungsvolle Erlebnisse. Seine Gelassenheit und Charisma ziehen andere an, während er durch ein erfülltes Leben inspiriert."""
            : """Der Adventurer meistert das Leben mit Leichtigkeit und fasziniert durch seine Ausstrahlung und Selbstsicherheit, ein Magnet für Erfolg und Menschen. Kreativ und strukturiert erreicht er seine Ziele in einem Leben voller spannender Herausforderungen.""";
      default:
        return 'No description available for this personality type.';
    }
  }
}