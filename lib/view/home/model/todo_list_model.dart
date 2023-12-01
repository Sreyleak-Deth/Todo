class Todo {
  String id;
  String title;
  bool completed;
  String details;
  String dateTime;
  String progress;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    required this.details,
    required this.dateTime,
    required this.progress,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] ?? false,
      details: json['details'],
      dateTime: json['dateTime'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'details': details,
      'dateTime': dateTime,
      'progress': progress,
    };
  }
}
