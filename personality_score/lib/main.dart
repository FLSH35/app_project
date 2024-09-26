import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(BachataApp());
}

class BachataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bachata Training App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: BachataHomePage(),
    );
  }
}

class BachataHomePage extends StatefulWidget {
  @override
  _BachataHomePageState createState() => _BachataHomePageState();
}

class _BachataHomePageState extends State<BachataHomePage> {
  double _tactValue = 140; // Default BPM value (within dancing range)
  late FlutterSoundPlayer _player;
  Timer? _beatTimer;
  bool _isPlaying = false;

  // Bachata exercises
  final List<String> exercises = [
    'Stand Figuren', 'Headrole', 'in die Knie/Rotation führen',
    'Offene Figuren', 'Fenster-Move', 'Verneigen-Move',
    'Cross-Body Lead | Rausdrehen', 'Half-Turn | Ausdrehen oder Half-Step + HüfteDrehen',
    'Cross-Body Lead | Hammerlock', 'Figur Salsamás 1',
    'Platztausch. Offene Haltung', 'Drehen. Hand auf Bauch.',
    'Halb-Drehung. Hände fallen lassen.',
    'Platztausch. Geschlossene Haltung', 'Halb-Drehung',
    'Basic.NachVorne.Half-Basic.FollowerTurn.LeaderTurn.FollowerTurn.',
    'Drehung links/rechts', 'Half-Basic', 'Step Tap', 'Vorwärts',
    'Diagonal Step', 'ÜberKreuz. Vorne/Hinten', 'Rock Step',
    'Box Step', 'Merengue Step', 'Diagonal Basic', 'Twist Spin', 'Trible Step'
  ];

  // Categories for each exercise
  Map<String, Map<String, bool>> exerciseCategories = {};

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _initPlayer();  // Initialize the player
    _loadSavedData(); // Load saved checkbox values
    _startTact(); // Start the beat when the app starts
  }

  // Initialize the player
  Future<void> _initPlayer() async {
    await _player.openPlayer();  // openPlayer() should be used in recent versions
  }

  @override
  void dispose() {
    _beatTimer?.cancel();
    _player.closePlayer(); // Close the player when done
    super.dispose();
  }

  // Start the beat based on tact value (BPM)
  void _startTact() {
    _beatTimer?.cancel(); // Cancel any previous timer
    int interval = (60000 / _tactValue).round(); // Calculate interval in milliseconds

    _beatTimer = Timer.periodic(Duration(milliseconds: interval), (Timer timer) {
      _playBeat(); // Play the beep sound
    });
  }

  // Play a beep sound from the asset
  Future<void> _playBeat() async {
    // Stop the player if it's already playing
    if (_isPlaying) {
      await _player.stopPlayer();
    }

    try {
      await _player.startPlayer(
        fromURI: 'assets/beep.mp3',  // Path to the asset
        codec: Codec.mp3,            // Codec of the audio file
      );
      _isPlaying = true;  // Mark that the player is now playing
    } catch (e) {
      print("Error: $e");
    }
  }

  // Save the checkbox values to local storage
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> savedData = {};

    exerciseCategories.forEach((exercise, categories) {
      savedData[exercise] = jsonEncode(categories);
    });

    prefs.setString('exerciseData', jsonEncode(savedData));
  }

  // Load the saved checkbox values from local storage
  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDataString = prefs.getString('exerciseData');

    if (savedDataString != null) {
      Map<String, dynamic> savedData = jsonDecode(savedDataString);

      savedData.forEach((exercise, categoriesJson) {
        Map<String, dynamic> categories = jsonDecode(categoriesJson);
        exerciseCategories[exercise] = categories.map((category, value) => MapEntry(category, value as bool));
      });
    } else {
      // Initialize default values if there's no saved data
      exercises.forEach((exercise) {
        exerciseCategories[exercise] = {
          'Trained Today': false,
          'Easy': false,
          'Middle': false,
          'Hard': false,
          'Use More Often': false,
        };
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bachata Training'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Slider for adjusting tact
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Adjust Tact (BPM): ${_tactValue.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.white),
                ),
                Slider(
                  value: _tactValue,
                  min: 120, // Lower end of normal Bachata BPM range
                  max: 200, // Higher end of normal Bachata BPM range
                  divisions: 80,
                  label: _tactValue.toString(),
                  onChanged: (double value) {
                    setState(() {
                      _tactValue = value;
                      _startTact(); // Restart tact with new BPM value
                    });
                  },
                ),
              ],
            ),
          ),

          // List of Exercises
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                String exercise = exercises[index];
                return ExpansionTile(
                  title: Text(
                    exercise,
                    style: TextStyle(color: Colors.white),
                  ),
                  children: exerciseCategories[exercise]!.keys.map((category) {
                    return CheckboxListTile(
                      title: Text(category, style: TextStyle(color: Colors.white70)),
                      value: exerciseCategories[exercise]![category],
                      onChanged: (bool? value) {
                        setState(() {
                          exerciseCategories[exercise]![category] = value!;
                          _saveData(); // Save the updated value
                        });
                      },
                      activeColor: Colors.blueAccent,
                      checkColor: Colors.white,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
