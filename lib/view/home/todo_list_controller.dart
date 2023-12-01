import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/view/home/model/todo_list_model.dart';

class TodoListController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController progressController = TextEditingController();

  RxList<Todo> todos = <Todo>[].obs;
  RxList<Todo> filteredTodos = <Todo>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get selectedProgress => _selectedProgress;

  set selectedProgress(String value) {
    _selectedProgress = value;
    update();
  }

  String _selectedProgress = 'Start';

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    filterTodos('');
  }

  @override
  void onClose() {
    titleController.dispose();
    detailsController.dispose();
    dateTimeController.dispose();
    super.onClose();
  }

  void clearTextControllers() {
    titleController.clear();
    detailsController.clear();
    dateTimeController.clear();
    progressController.clear();
  }

  Future<void> saveTodos() async {
    try {
      final List<Map<String, dynamic>> todosMapList =
          todos.map((todo) => todo.toJson()).toList();

      await _firestore.collection('todos').doc('todosDocument').set({
        'todos': todosMapList,
      });
    } catch (e) {
      print('Error saving todos to Firestore: $e');
    }
  }

  Future<void> loadTodos() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('todos').doc('todosDocument').get();

      if (snapshot.exists) {
        final List<Map<String, dynamic>> todosMapList =
            List<Map<String, dynamic>>.from(snapshot.data()!['todos']);
        todos.assignAll(
          todosMapList.map((todoMap) => Todo.fromJson(todoMap)).toList(),
        );
      }
    } catch (e) {
      print('Error loading todos from Firestore: $e');
    }
  }

  void addTodoWithDetails({
    required String id,
    required String title,
    required String details,
    required String dateTime,
    required String progress,
  }) {
    final existingTodo = todos.firstWhere(
      (todo) => todo.title == title,
      orElse: () => Todo(
        id: '',
        title: '',
        details: '',
        dateTime: '',
        progress: '',
      ),
    );

    if (existingTodo.title.isEmpty) {
      final newTodo = Todo(
        id: id,
        title: title,
        details: details,
        dateTime: dateTime,
        progress: progress,
      );
      todos.add(newTodo);
      saveTodos();
      filterTodos('');
      update();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void filterTodos(String searchText) {
    filteredTodos.assignAll(todos
        .where((todo) =>
            todo.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList());
    update();
  }

  void selectDateAndTime(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text =
            DateFormat('yyyy-MM-dd HH:mm a').format(selectedDateTime);
      }
    }
  }
}
