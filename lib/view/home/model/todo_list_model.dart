import 'dart:convert';

class Todo {
  late String title;
  late bool completed;
  late String details;
  late String dateTime;
  late String progress;

  Todo({
    required this.title,
    this.completed = false,
    required this.details,
    required this.dateTime,
    required this.progress,
  });

  String toJsonString() {
    return '''
      {
        "title": "$title",
        "completed": $completed,
        "details": "$details",
        "dateTime": "$dateTime",
        "progress": "$progress"
      }
    ''';
  }

  factory Todo.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Todo(
      title: json['title'],
      completed: json['completed'],
      details: json['details'],
      dateTime: json['dateTime'],
      progress: json['progress'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'completed': completed,
  //     'details': details,
  //     'dateTime': dateTime,
  //     'progress': progress,
  //   };
  // }

  // factory Todo.fromJson(Map<String, dynamic> json) {
  //   return Todo(
  //     title: json['title'],
  //     completed: json['completed'],
  //     details: json['details'],
  //     dateTime: json['dateTime'],
  //     progress: json['progress'],
  //   );
  // }
}
