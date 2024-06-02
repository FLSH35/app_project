import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  Future<List<Question>> loadQuestions(String fileName) async {
    final String response = await rootBundle.loadString('assets/$fileName');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Question.fromJson(json as Map<String, dynamic>)).toList();
  }
}
