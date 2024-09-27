import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(BachataApp());
}

class BachataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bachata Training App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: BachataHomePage(),
    );
  }
}
