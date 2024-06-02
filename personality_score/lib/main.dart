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

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalScore => _totalScore;
  int get currentPage => _currentPage;

  Future<void> loadQuestions(String fileName) async {
    _questions = await _questionService.loadQuestions(fileName);
    notifyListeners();
  }

  void answerQuestion(String value) {
    _totalScore += int.parse(value);
    _currentQuestionIndex++;
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
    notifyListeners();
  }

  String getResultLink() {
    int maxScore = _questions.length * 3;
    if (_totalScore >= maxScore * 0.6) {
      return "https://forms.gle/8UAagk3ukD1v1X1x6"; // Link to Conscious Competence
    } else {
      return "https://forms.gle/2BBfP6iXnnqkFUDk8"; // Link to Incompetence
    }
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
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestions.length,
                  itemBuilder: (context, index) {
                    Question question = currentQuestions[index];
                    return ListTile(
                      title: Text(question.text),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          int value = i - 3; // Values range from -3 to +3
                          return Expanded(
                            child: RadioListTile<int>(
                              value: value,
                              groupValue: null, // Needs to be set to the current answer's value
                              onChanged: (val) {
                                model.answerQuestion(val.toString());
                              },
                              title: Text((value + 3).toString()), // Display 1-7 instead of -3 to +3
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
                        String resultLink = model.getResultLink();
                        // Implement email sending logic here using resultLink
                        print('Result Link: $resultLink');
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
