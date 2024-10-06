import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personality_score/models/questionaire_model.dart';
import '../auth/auth_service.dart';
import '../models/question.dart';
import 'package:lottie/lottie.dart';
import 'custom_app_bar.dart';

class QuestionnaireDesktopLayout extends StatefulWidget {
  final ScrollController scrollController;

  QuestionnaireDesktopLayout({required this.scrollController});

  @override
  _QuestionnaireDesktopLayoutState createState() => _QuestionnaireDesktopLayoutState();
}

class _QuestionnaireDesktopLayoutState extends State<QuestionnaireDesktopLayout> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final model = Provider.of<QuestionnaireModel>(context, listen: false);

    if (model.questions.isEmpty) {
      await model.loadQuestions('Kompetenz');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionnaireModel>(context); // Retrieve the model

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight + 70), // Adjust padding to push content below the progress bar
            child: Container(
              color: Color(0xFF242424),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            _buildQuestionsList(context, model),
                            _buildNavigationButtons(context, model),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom AppBar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title: 'Personality Score',
            ),
          ),

          // Progress bar at the top, in front of everything
          Positioned(
            top: kToolbarHeight + 60,
            left: 0,
            right: 0,
            child: CustomProgressBar(
              totalSteps: (model.questions.length / 7).ceil(),
              currentStep: model.currentPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsList(BuildContext context, QuestionnaireModel model) {
    int start = model.currentPage * 7;
    int end = start + 7;
    List<Question> currentQuestions = model.questions.sublist(
        start, end > model.questions.length ? model.questions.length : end);

    return Column(
      children: currentQuestions.map((question) {
        int questionIndex = start + currentQuestions.indexOf(question);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0), // Adjusted to reduce vertical space
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Color(0xFF242424),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Question text on the left side
              Expanded(
                flex: 3,
                child: Text(
                  question.text,
                  style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Slider on the right side
              Expanded(
                flex: 2,
                child: Column(
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
                      thumbColor: Color(0xFFCB9935),
                    ),
                    SizedBox(height: 8.0),

                    // Text labels below the slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NEIN',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'EHER NEIN',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'EHER JA',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'JA',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }





  Widget _buildNavigationButtons(BuildContext context, QuestionnaireModel model) {
    int questionsPerPage = 7; // Number of questions per page
    int start = model.currentPage * questionsPerPage;
    int end = start + questionsPerPage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous page button
        if (model.currentPage > 0)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              backgroundColor: Colors.black,
              side: BorderSide(color: Color(0xFFCB9935)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            onPressed: () => model.prevPage(),
            child: Text(
              'Zurück',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
            ),
          ),

        // Next page button
        if (end < model.questions.length)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              backgroundColor: Color(0xFFCB9935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            onPressed: () {
              model.nextPage(context);
              _scrollToFirstQuestion(context);
            },
            child: Text(
              'Weiter',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
            ),
          ),

        // "Fertigstellen" button for the first test
        if (end >= model.questions.length && !model.isFirstTestCompleted)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              backgroundColor: Color(0xFFCB9935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            onPressed: () {
              model.completeFirstTest(context);
              _scrollToFirstQuestion(context);
            },
            child: Text(
              'Fertigstellen',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
            ),
          ),

        // "Fertigstellen" button for the second test
        if (end >= model.questions.length &&
            model.isFirstTestCompleted &&
            !model.isSecondTestCompleted)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              backgroundColor: Color(0xFFCB9935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            onPressed: () {
              model.completeSecondTest(context);
              _scrollToFirstQuestion(context);
            },
            child: Text(
              'Fertigstellen',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Roboto', fontSize: 18),
            ),
          ),

        // Final "Fertigstellen" button for the last test
        if (end >= model.questions.length && model.isSecondTestCompleted)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              backgroundColor: Color(0xFFCB9935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            onPressed: () {
              model.completeFinalTest(context);
              _scrollToFirstQuestion(context);
            },
            child: Text(
              'Fertigstellen',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: 18),
            ),
          ),
      ],
    );
  }

  void _scrollToFirstQuestion(BuildContext context) {
    widget.scrollController.animateTo(
      0.0, // Scroll to the very top
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 8,
                  color: index <= currentStep ? Color(0xFFCB9935) : Colors.grey,
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: index < currentStep ? Color(0xFFCB9935) : Colors.grey,
                  child: index < currentStep
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
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
