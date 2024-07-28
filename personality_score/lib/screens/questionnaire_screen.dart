import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/models/questionaire_model.dart';
import '../models/question.dart';
import 'package:lottie/lottie.dart';
import 'custom_app_bar.dart'; // Import the custom AppBar

class QuestionnaireScreen extends StatelessWidget {
  final List<Map<String, String>> personalityTypes = [
    {"value": "Individual", "name": "Individual"},
    {"value": "Traveller", "name": "Traveller"},
    {"value": "Reacher", "name": "Reacher"},
    {"value": "Explorer", "name": "Explorer"},
    {"value": "Resident", "name": "Resident"},
    {"value": "Anonymous", "name": "Anonymous"},
    {"value": "LifeArtist", "name": "Life Artist"},
    {"value": "Adventurer", "name": "Adventurer"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Personality Score',
        personalityTypes: personalityTypes,
      ),
      body: Stack(
        children: [
          // Background color
          Positioned.fill(
            child: Container(
              color: Color(0xFF242424),
            ),
          ),
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/wasserzeichen.webp', // Replace with your background image path
              fit: BoxFit.contain,
            ),
          ),
          Consumer<QuestionnaireModel>(
            builder: (context, model, child) {
              if (model.questions.isEmpty) {
                model.loadQuestions('Kompetenz');
                model.loadProgress(); // Load user progress
                return Center(child: CircularProgressIndicator());
              }

              int totalSteps = (model.questions.length / 7).ceil();
              int currentStep = model.currentPage;
              int answeredQuestions = model.answers.where((answer) => answer != null).length;
              int totalQuestions = model.questions.length;

              int start = model.currentPage * 7;
              int end = start + 7;
              List<Question> currentQuestions = model.questions.sublist(start, end > model.questions.length ? model.questions.length : end);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Personality Score',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Center(
                          child: Text(
                            '$answeredQuestions / $totalQuestions',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomProgressBar(totalSteps: totalSteps, currentStep: currentStep),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestions.length,
                      itemBuilder: (context, index) {
                        Question question = currentQuestions[index];
                        int questionIndex = start + index;
                        return Container(
                          color: Colors.transparent, // Ensure the container background is transparent
                          child: ListTile(
                            title: Center(
                              child: Text(
                                question.text,
                                style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Slider(
                                  value: (model.answers[questionIndex] ?? 0).toDouble(),
                                  onChanged: (val) {
                                    model.answerQuestion(questionIndex, val.toInt());
                                  },
                                  min: 0,
                                  max: 10,
                                  divisions: 10,
                                  label: model.answers[questionIndex]?.toString() ?? '0',
                                  activeColor: Color(0xFFCB9935),
                                  inactiveColor: Colors.grey,
                                ),
                                Text(
                                  model.answers[questionIndex]?.toString() ?? '0',
                                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                ),
                              ],
                            ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: BorderSide(color: Color(0xFFCB9935)),
                          ),
                          onPressed: () => model.prevPage(),
                          child: Text(
                            'Zurück',
                            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                      if (end < model.questions.length)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                          ),
                          onPressed: () => model.nextPage(context),
                          child: Text(
                            'Weiter',
                            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                      if (end >= model.questions.length && !model.isFirstTestCompleted)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                          ),
                          onPressed: () => model.completeFirstTest(context),
                          child: Text(
                            'Fertigstellen',
                            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                      if (end >= model.questions.length && model.isFirstTestCompleted && !model.isSecondTestCompleted)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                          ),
                          onPressed: () {
                            model.completeSecondTest(context);
                            _showRewardAnimation(context, 'stars.json'); // Show reward animation
                          },
                          child: Text(
                            'Fertigstellen',
                            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                      if (end >= model.questions.length && model.isSecondTestCompleted)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                          ),
                          onPressed: () {
                            model.completeFinalTest(context);
                          },
                          child: Text(
                            'Fertigstellen',
                            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
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

class CustomProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  CustomProgressBar({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 4,
                  color: index <= currentStep ? Color(0xFFCB9935) : Colors.grey,
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: index < currentStep ? Color(0xFFCB9935) : Colors.grey,
                  child: index < currentStep
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                      : Container(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
