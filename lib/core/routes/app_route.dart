import 'package:get/get.dart';
import 'package:todo_list/view/home/todo_list_binding.dart';
import 'package:todo_list/view/home/todo_list_view.dart';

class Path {
  static const TODO_LIST = '/todo_list';
}

abstract class Route {
  Route._();
  static const TODO_LIST = Path.TODO_LIST;
}

class AppPage {
  AppPage._();
  static final route = [
    GetPage(
      name: Path.TODO_LIST,
      page: () => TodoListView(),
      binding: TodoListBinding(),
    ),
  ];
}
