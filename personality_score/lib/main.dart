import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/question_service.dart';
import 'models/question.dart';

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

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalScore => _totalScore;
  int get currentPage => _currentPage;
  List<int?> get answers => _answers;

  Future<void> loadQuestions(String fileName) async {
    _questions = await _questionService.loadQuestions(fileName);
    _answers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }

  void answerQuestion(int index, int value) {
    _answers[index] = value;
    _totalScore = _answers.where((a) => a != null).fold(0, (sum, a) => sum + a!);
    notifyListeners();
  }

  void nextPage() {
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
    _answers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }

  double getProgress() {
    if (_questions.isEmpty) return 0.0;
    return (_currentPage + 1) / (_questions.length / 7).ceil();
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
            model.loadQuestions('kompetenz.json'); // Load initial questions
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
                      onPressed: () => model.nextPage(),
                      child: Text('Next'),
                    ),
                  if (end >= model.questions.length)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Result'),
                              content: Text('Your total score is: ${model.totalScore}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Finish'),
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
