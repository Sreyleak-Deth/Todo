import 'package:get/get.dart';
import 'package:todo_list/view/home/todo_list_controller.dart';

class TodoListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoListController>(
      () => TodoListController(),
    );
  }
}
