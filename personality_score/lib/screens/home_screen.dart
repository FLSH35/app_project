import 'package:flutter/material.dart';
import 'custom_app_bar.dart'; // Import the custom AppBar

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.33);

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
      backgroundColor: Color(0xFF242424),
      appBar: CustomAppBar(
        title: 'Personality Score',
        personalityTypes: personalityTypes,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/wasserzeichen.webp',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "It’s so incredible to finally be understood.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Only 10 minutes to get a 'freakishly accurate' description of who you are and why you do things the way you do.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'Roboto'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 27),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/questionnaire');
                          },
                          child: Text('Take the Test', style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 23)),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 300,
                        child: Image.asset(
                          'assets/home.png',
                          opacity: const AlwaysStoppedAnimation(.75),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatistic('300K+', 'Tests taken today'),
                            _buildStatistic('19M+', 'Tests taken in Germany'),
                            _buildStatistic('1229M+', 'Total tests taken'),
                            _buildStatistic('91.2%', 'Results rated as accurate or very accurate'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PERSONALITY TYPES",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Understand others",
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(height: 20), // Add space between texts
                                      Text(
                                        "In our free type descriptions you’ll learn what really drives, inspires, and worries different personality types, helping you build more meaningful relationships.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontSize: 22,
                                        ),
                                        textAlign: TextAlign.center, // Center align the text
                                      ),
                                      SizedBox(height: 20), // Add space before the button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFCB9935),
                                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 27),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed('/personality_types');
                                        },
                                        child: Text(
                                          'Learn More',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontSize: 23,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: 500, // set your desired width
                                height: 500, // set your desired height
                                child: Image.asset('assets/Adventurer.webp'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 150), // distance to testimonials
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "TESTIMONIALS",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "See what others have to say",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 260,

                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: 10,
                                    onPageChanged: (int index) {
                                      setState(() {});
                                    },
                                    itemBuilder: (context, index) {
                                      return _buildTestimonialCard(
                                        context,
                                        'assets/Adventurer.webp',
                                        'Name $index',
                                        'Type $index',
                                        'This is a testimonial review text number $index.',
                                      );
                                    },
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_left, color: Color(0xFFCB9935)),
                                      onPressed: () {
                                        _pageController.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_right, color: Color(0xFFCB9935)),
                                      onPressed: () {
                                        _pageController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Curious how accurate we are about you?",
                          style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCB9935),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 27),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/questionnaire');
                          },
                          child: Text('Take the Test', style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 23)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String value, String description) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
        ),
        Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
      ],
    );
  }

  Widget _buildTestimonialCard(BuildContext context, String imagePath, String name, String type, String testimonial) {
    return Card(
      color: Color(0x51CB9935),
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath, width: 100, height: 100),
                SizedBox(width: 21),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              testimonial,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
