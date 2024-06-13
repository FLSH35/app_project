import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/question_service.dart';
import 'models/question.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => QuestionnaireModel(),
        child: QuestionnaireScreen(),
      ),
    );
  }
}

class QuestionnaireModel with ChangeNotifier {
  final QuestionService _questionService = QuestionService();
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  int _currentPage = 0;
  List<int?> _answers = [];
  String? _personalityType;
  int _progress = 0;
  bool _isFirstTestCompleted = false;
  bool _isSecondTestCompleted = false;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalScore => _totalScore;
  int get currentPage => _currentPage;
  List<int?> get answers => _answers;
  String? get personalityType => _personalityType;
  int get progress => _progress;
  bool get isFirstTestCompleted => _isFirstTestCompleted;
  bool get isSecondTestCompleted => _isSecondTestCompleted;

  Future<void> loadQuestions(String set) async {
    _questions = await _questionService.loadQuestions(set);
    _answers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }

  void answerQuestion(int index, int value) {
    _answers[index] = value;
    _totalScore = _answers.where((a) => a != null).fold(0, (sum, a) => sum + a!);
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    _currentPage++;
    notifyListeners();
  }

  void prevPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void reset() {
    _totalScore = 0;
    _currentQuestionIndex = 0;
    _currentPage = 0;
    _progress = 0;
    _answers = List<int?>.filled(_questions.length, null);
    _personalityType = null;
    _isFirstTestCompleted = false;
    _isSecondTestCompleted = false;
    notifyListeners();
  }

  double getProgress() {
    if (_questions.isEmpty) return 0.0;
    return (_currentPage + 1) / (_questions.length / 7).ceil();
  }

  void completeFirstTest(BuildContext context) {
    _isFirstTestCompleted = true;
    String message;
    List<String> teamCharacters;
    String nextSet;

    if (_totalScore > 50) {
      message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
      teamCharacters = ["Life Artist.webp", "Individual.webp", "Adventurer.webp", "Traveller.webp"];
      nextSet = 'BewussteInkompetenz';
    } else {
      message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
      teamCharacters = ["resident.webp", "explorer.webp", "reacher.webp", "Anonymous.webp"];
      nextSet = 'BewussteKompetenz';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Total Score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: teamCharacters.map((character) => Image.asset('assets/$character', width: 50, height: 50)).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                loadQuestions(nextSet); // Load next set of questions
                _currentPage = 0;
                _totalScore = 0;
                _answers = List<int?>.filled(_questions.length, null);
                notifyListeners();
                Navigator.of(context).pop();
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void completeSecondTest(BuildContext context) {
    _isSecondTestCompleted = true;
    String message;
    List<String> teamCharacters;
    String nextSet;

    if (_totalScore > 50) {
      if (_questions.first.set == 'BewussteInkompetenz') {
        message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
        teamCharacters = ["Life Artist.webp", "Adventurer.webp"];
        nextSet = 'Lifeartist';
      } else {
        message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
        teamCharacters = ["Resident.webp", "Anonymous.webp"];
        nextSet = 'Resident';
      }
    } else {
      if (_questions.first.set == 'BewussteInkompetenz') {
        message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
        teamCharacters = ["Individual.webp", "Traveller.webp"];
        nextSet = 'Individual';
      } else {
        message = 'Your total score is: $_totalScore\n\nYou belong to the following team:';
        teamCharacters = ["Reacher.webp", "Explorer.webp"];
        nextSet = 'Reacher';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Total Score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: teamCharacters.map((character) => Image.asset('assets/$character', width: 50, height: 50)).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                loadQuestions(nextSet); // Load final set of questions
                _currentPage = 0;
                _totalScore = 0;
                _answers = List<int?>.filled(_questions.length, null);
                notifyListeners();
                Navigator.of(context).pop();
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void completeFinalTest(BuildContext context) {
    String finalCharacter;
    String finalCharacterDescription;

    if (_totalScore > 50) {
      if (_questions.first.set == 'Lifeartist') {
        finalCharacter = "Life Artist.webp";
        finalCharacterDescription = "Description of Life Artist...";
      } else {
        finalCharacter = "Resident.webp";
        finalCharacterDescription = "Description of Resident...";
      }
    } else {
      if (_questions.first.set == 'Lifeartist') {
        finalCharacter = "Adventurer.webp";
        finalCharacterDescription = "Description of Adventurer...";
      } else {
        finalCharacter = "Reacher.webp";
        finalCharacterDescription = "Description of Reacher...";
      }
    }

    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Final Character'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your final character is:'),
              SizedBox(height: 10),
              Image.asset('assets/$finalCharacter', width: 100, height: 100),
              SizedBox(height: 10),
              Text(finalCharacterDescription),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email to receive results',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Send email logic here (this is a placeholder)
                String email = emailController.text;
                print('Send results to: $email');
                Navigator.of(context).pop();
                reset(); // Reset the quiz
              },
              child: Text('Finish'),
            ),
            TextButton(
              onPressed: () {
                String shareText = 'My final character is $finalCharacter.\n\nDescription: $finalCharacterDescription';
                Share.share(shareText); // Share the result
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void setPersonalityType(String type) {
    _personalityType = type;
    notifyListeners();
  }
}

class QuestionnaireScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire'),
      ),
      body: Consumer<QuestionnaireModel>(
        builder: (context, model, child) {
          if (model.questions.isEmpty) {
            model.loadQuestions('Kompetenz'); // Load initial questions based on set name
            return Center(child: CircularProgressIndicator());
          }

          int start = model.currentPage * 7;
          int end = start + 7;
          List<Question> currentQuestions = model.questions.sublist(start, end > model.questions.length ? model.questions.length : end);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Personality Score',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              LinearProgressIndicator(
                value: model.getProgress(),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestions.length,
                  itemBuilder: (context, index) {
                    Question question = currentQuestions[index];
                    int questionIndex = start + index;
                    return ListTile(
                      title: Center(child: Text(question.text)),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (i) {
                          return Expanded(
                            child: RadioListTile<int>(
                              value: i,
                              groupValue: model.answers[questionIndex],
                              onChanged: (val) {
                                if (val != null) {
                                  model.answerQuestion(questionIndex, val);
                                }
                              },
                              title: Center(child: Text(i.toString())), // Display 0-3
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (model.currentPage > 0)
                    ElevatedButton(
                      onPressed: () => model.prevPage(),
                      child: Text('Previous'),
                    ),
                  if (end < model.questions.length)
                    ElevatedButton(
                      onPressed: () => model.nextPage(context),
                      child: Text('Next'),
                    ),
                  if (end >= model.questions.length && !model.isFirstTestCompleted)
                    ElevatedButton(
                      onPressed: () => model.completeFirstTest(context),
                      child: Text('Complete First Test'),
                    ),
                  if (end >= model.questions.length && model.isFirstTestCompleted && !model.isSecondTestCompleted)
                    ElevatedButton(
                      onPressed: () => model.completeSecondTest(context),
                      child: Text('Complete Second Test'),
                    ),
                  if (end >= model.questions.length && model.isSecondTestCompleted)
                    ElevatedButton(
                      onPressed: () => model.completeFinalTest(context),
                      child: Text('Finish Final Test'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
