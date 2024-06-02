import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final String text;
  final String value;  // Keep value as a string
  final int relevancy;
  final String set;

  Question({required this.text, required this.value, required this.relevancy, required this.set});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  int getValueAsInt() {
    return int.tryParse(value) ?? 0; // Convert value to integer, default to 0 if parsing fails
  }
}
