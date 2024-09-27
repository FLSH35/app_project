import 'dart:async';
import 'package:flutter/material.dart';
import 'exercise_data.dart';
import 'audio_service.dart';
import 'package:image_picker/image_picker.dart';  // For picking videos
import 'package:just_audio/just_audio.dart';  // For audio playback
import 'video_player_page.dart';  // Video player screen

class BachataHomePage extends StatefulWidget {
  @override
  _BachataHomePageState createState() => _BachataHomePageState();
}

class _BachataHomePageState extends State<BachataHomePage> {
  double _playbackSpeed = 1.0; // Default playback speed
  int _intervalMs = 500; // Interval between beats in milliseconds (500 ms)
  double _bpm = 0; // Calculated beats per minute based on adjusted speed

  final ExerciseData _exerciseData = ExerciseData();
  final ImagePicker _picker = ImagePicker(); // Image picker for video
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final String _beatFile = 'assets/monotonous_beat.mp3'; // Path to your 10-minute beat file

  @override
  void initState() {
    super.initState();
    _calculateBPM(); // Calculate the BPM on initialization
    _exerciseData.loadExercisesFromFile().then((_) {
      setState(() {});
    });
    _audioPlayer.setAsset(_beatFile);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Function to calculate the BPM based on the interval and playback speed
  void _calculateBPM() {
    setState(() {
      _bpm = (60000 / _intervalMs) *
          _playbackSpeed; // 60000 ms in 1 minute, adjusted by speed
    });
  }

  Future<void> _playBeat() async {
    await _audioPlayer.setSpeed(_playbackSpeed); // Set the playback speed
    await _audioPlayer.seek(Duration.zero); // Reset the audio file
    await _audioPlayer.play(); // Play the audio file
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _stopBeat() async {
    await _audioPlayer.stop(); // Stop the beat
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _renameExercise(String oldName) async {
    TextEditingController _controller = TextEditingController();
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Exercise'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _exerciseData.renameExercise(oldName, newName);
      });
    }
  }

  void _deleteExercise(String exercise) {
    setState(() {
      _exerciseData.deleteExercise(exercise);
    });
  }

  // Function to add a new exercise
  Future<void> _addExercise() async {
    TextEditingController _controller = TextEditingController();
    String? newExercise = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Exercise'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter exercise name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (newExercise != null && newExercise.isNotEmpty) {
      setState(() {
        _exerciseData.addExercise(newExercise); // Add new exercise
      });
    }
  }

  // Pick a video and associate it with the exercise
  Future<void> _pickVideo(String exercise) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _exerciseData.updateVideoPath(exercise, video.path);
      });
    }
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
          // Show the calculated BPM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'BPM: ${_bpm.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // Slider for adjusting playback speed
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Adjust Playback Speed: ${_playbackSpeed.toStringAsFixed(1)}x',
                  style: TextStyle(color: Colors.white),
                ),
                Slider(
                  value: _playbackSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: _playbackSpeed.toString(),
                  onChanged: (double value) {
                    setState(() {
                      _playbackSpeed = value;
                      _calculateBPM();  // Recalculate BPM based on the new speed
                    });
                    if (_isPlaying) {
                      _audioPlayer.setSpeed(_playbackSpeed);  // Update speed while playing
                    }
                  },
                ),
              ],
            ),
          ),

          // Button to play or stop the beat
          ElevatedButton(
            onPressed: _isPlaying ? _stopBeat : _playBeat,
            child: Text(_isPlaying ? 'Stop Beat' : 'Start Beat'),
          ),

          // Add New Exercise Button
          ElevatedButton(
            onPressed: _addExercise,
            child: Text('Add New Exercise'),
          ),

          // List of Exercises
          Expanded(
            child: ListView.builder(
              itemCount: _exerciseData.exercises.length,
              itemBuilder: (context, index) {
                String exercise = _exerciseData.exercises[index];

                return ExpansionTile(
                  title: Text(exercise, style: TextStyle(color: Colors.white)),
                  children: [
                    // Ensure that the exerciseCategories[exercise] is not null
                    if (_exerciseData.exerciseCategories[exercise] != null)
                      Column(
                        children: _exerciseData.exerciseCategories[exercise]!.keys.map((category) {
                          return CheckboxListTile(
                            title: Text(category, style: TextStyle(color: Colors.white70)),
                            value: _exerciseData.exerciseCategories[exercise]![category],
                            onChanged: (bool? value) {
                              setState(() {
                                _exerciseData.exerciseCategories[exercise]![category] = value!;
                                _exerciseData.saveExercisesToFile();
                              });
                            },
                            activeColor: Colors.blueAccent,
                            checkColor: Colors.white,
                          );
                        }).toList(),
                      ),

                    // Video actions
                    ListTile(
                      title: Text('Pick Video', style: TextStyle(color: Colors.white)),
                      trailing: Icon(Icons.video_library, color: Colors.white),
                      onTap: () => _pickVideo(exercise),
                    ),
                    if (_exerciseData.exerciseVideos[exercise] != null)
                      ListTile(
                        title: Text('Play Video', style: TextStyle(color: Colors.white)),
                        trailing: Icon(Icons.play_arrow, color: Colors.white),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(videoPath: _exerciseData.exerciseVideos[exercise]!),
                            ),
                          );
                        },
                      ),

                    // Rename/Delete Exercise buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _renameExercise(exercise),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExercise(exercise),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
