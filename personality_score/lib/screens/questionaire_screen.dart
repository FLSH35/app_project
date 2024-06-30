import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/main.dart';

import '../models/question.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

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
            model.loadQuestions('Kompetenz');
            model.loadProgress(); // Load user progress
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      onPressed: () {
                        model.completeSecondTest(context);
                        _showRewardAnimation(context, 'stars.json'); // Show reward animation
                      },
                      child: Text('Complete Second Test'),
                    ),
                  if (end >= model.questions.length && model.isSecondTestCompleted)
                    ElevatedButton(
                      onPressed: () {
                        model.completeFinalTest(context);
                        _showRewardAnimation(context, 'stars.json'); // Show reward animation
                      },
                      child: Text('Finish Final Test'),
                    ),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  void _showRewardAnimation(BuildContext context, String animationAsset) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close the transparent overlay after 2 seconds
        });

        return Stack(
          alignment: Alignment.center,
          children: [
            // Transparent overlay
            Container(
              color: Colors.transparent, // Transparent color
            ),
            // Reward animation
            Lottie.asset(
              'assets/$animationAsset',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ],
        );
      },
    );
  }
}