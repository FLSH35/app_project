import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Map<String, String>> personalityTypes;

  CustomAppBar({required this.title, required this.personalityTypes});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF020202),
      leading: IconButton(
        icon: Image.asset('assets/goldbaum.webp'), // Replace with the actual path to your logo PNG
        onPressed: () {
          Navigator.of(context).pushNamed('/home');
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  dropdownColor: Color(0xFF242424),
                  items: personalityTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type["value"],
                      child: Text(
                        type["name"]!,
                        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.of(context).pushNamed(
                        '/personality_types',
                        arguments: value,
                      );
                    }
                  },
                  hint: Text(
                    "Personality Types",
                    style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  dropdownColor: Color(0xFF242424),
                  items: [
                    DropdownMenuItem(
                      value: "a",
                      child: Text("a", style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
                    ),
                    DropdownMenuItem(
                      value: "b",
                      child: Text("b", style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
                    ),
                  ],
                  onChanged: (value) {},
                  hint: Text(
                    "Team Description",
                    style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person, color: Color(0xFFCB9935)),
          onPressed: () {
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFCB9935)),
          onPressed: () {
            Navigator.of(context).pushNamed('/questionnaire');
          },
          child: Text(
            'Take the Test ->',
            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
