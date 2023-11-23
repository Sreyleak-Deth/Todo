// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/view/home/model/todo_list_model.dart';

class TodoListController extends GetxController {
  RxList<Todo> todos = <Todo>[].obs;
  var filteredTodos = <Todo>[].obs;
  bool visibility = false;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    filterTodos('');
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void saveTodos() {
  //   final List<Map<String, dynamic>> todosMapList =
  //       todos.map((todo) => todo.toJson()).toList();

  //   _firestore.collection('todos').doc('todosDocument').set({
  //     'todos': todosMapList,
  //   });
  // }

  // Future<void> loadTodos() async {
  //   final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await _firestore.collection('todos').doc('todosDocument').get();

  //   if (snapshot.exists) {
  //     final List<Map<String, dynamic>> todosMapList = snapshot.data()!['todos'];
  //     todos.assignAll(
  //       todosMapList.map((todoMap) => Todo.fromJson(todoMap)).toList(),
  //     );
  //   }
  // }

  void addTodoWithDetails({
    required String title,
    required String details,
    required String dateTime,
    required String progress,
  }) {
    final existingTodo = todos.firstWhere(
      (todo) => todo.title == title,
      orElse: () => Todo(
        title: '',
        details: '',
        dateTime: '',
        progress: '',
      ),
    );

    if (existingTodo.title.isEmpty) {
      final newTodo = Todo(
        title: title.trim(),
        details: details,
        dateTime: dateTime,
        progress: progress,
      );
      todos.add(newTodo);
      saveTodos();
      filterTodos('');

      update();
    } else {
      Future.delayed(Duration.zero, () {
        Get.defaultDialog(
          title: 'Duplicate Item',
          middleText:
              'The todo item already exists. Please use a different title.',
          textConfirm: 'OK',
          onConfirm: () {
            Get.back();
          },
        );
      });
    }
  }

  void removeTodo(int index) {
    todos.removeAt(index);
    saveTodos();
    filterTodos('');
  }

  void editTodo(int index, Todo updatedTodo) {
    todos[index] = updatedTodo;
    saveTodos();
    filterTodos('');
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> todosStringList =
        todos.map((todo) => todo.toJsonString()).toList();
    prefs.setStringList('todos', todosStringList);
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? todosStringList = prefs.getStringList('todos');
    if (todosStringList != null) {
      todos.assignAll(todosStringList.map((todoString) {
        return Todo.fromJsonString(todoString);
      }));
    }
  }

  void filterTodos(String searchText) {
    filteredTodos.assignAll(todos
        .where((todo) =>
            todo.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList());
    update();
  }

  void removeSpace(String remove) {}
}
