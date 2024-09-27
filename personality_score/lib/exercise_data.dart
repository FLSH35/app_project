import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ExerciseData {
  List<String> exercises = [];
  Map<String, Map<String, bool>> exerciseCategories = {};
  Map<String, String?> exerciseVideos = {}; // Store the video file paths for each exercise

  // File to store the exercises
  String get _fileName => 'exercises.json';

  ExerciseData() {
    loadExercisesFromFile(); // Load from file on initialization
  }

  // Load exercises from the local JSON file
  Future<void> loadExercisesFromFile() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/$_fileName');

      if (await file.exists()) {
        String contents = await file.readAsString();
        Map<String, dynamic> data = jsonDecode(contents);

        exercises = List<String>.from(data['exercises']);

        // Safely parse exercise categories and initialize missing ones
        Map<String, dynamic> loadedCategories = data['exerciseCategories'] ?? {};
        loadedCategories.forEach((exercise, categoriesJson) {
          exerciseCategories[exercise] = Map<String, bool>.from(categoriesJson);
        });

        // Ensure all exercises have initialized categories
        exercises.forEach((exercise) {
          if (!exerciseCategories.containsKey(exercise)) {
            exerciseCategories[exercise] = {
              'Trained Today': false,
              'Easy': false,
              'Middle': false,
              'Hard': false,
              'Use More Often': false,
            };
          }
        });

        // Safely load video paths
        exerciseVideos = Map<String, String?>.from(data['exerciseVideos'] ?? {});
      } else {
        // If no file exists, initialize with default values
        _initializeDefaultCategories();
        _initializeDefaultVideos();
        saveExercisesToFile(); // Save the initial data to the file
      }
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  // Initialize default categories
  void _initializeDefaultCategories() {
    exercises = [
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

  // Initialize default video paths
  void _initializeDefaultVideos() {
    exercises.forEach((exercise) {
      exerciseVideos[exercise] = null; // No video selected by default
    });
  }

  // Save the exercises, categories, and videos to the local JSON file
  Future<void> saveExercisesToFile() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/$_fileName');

      Map<String, dynamic> data = {
        'exercises': exercises,
        'exerciseCategories': exerciseCategories,
        'exerciseVideos': exerciseVideos,
      };

      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving exercises: $e');
    }
  }

  // Update video path for an exercise
  void updateVideoPath(String exercise, String videoPath) {
    exerciseVideos[exercise] = videoPath;
    saveExercisesToFile(); // Save immediately after update
  }

  // Add a new exercise
  void addExercise(String exercise) {
    if (!exercises.contains(exercise)) {
      exercises.add(exercise);
      exerciseCategories[exercise] = {
        'Trained Today': false,
        'Easy': false,
        'Middle': false,
        'Hard': false,
        'Use More Often': false,
      };
      exerciseVideos[exercise] = null;
      saveExercisesToFile();
    }
  }

  // Rename an exercise
  void renameExercise(String oldName, String newName) {
    if (exercises.contains(oldName) && !exercises.contains(newName)) {
      int index = exercises.indexOf(oldName);
      exercises[index] = newName;

      // Rename in categories and videos
      exerciseCategories[newName] = exerciseCategories.remove(oldName)!;
      exerciseVideos[newName] = exerciseVideos.remove(oldName);

      saveExercisesToFile(); // Save the changes
    }
  }

  // Delete an exercise
  void deleteExercise(String exercise) {
    exercises.remove(exercise);
    exerciseCategories.remove(exercise);
    exerciseVideos.remove(exercise);

    saveExercisesToFile(); // Save the changes
  }
}
