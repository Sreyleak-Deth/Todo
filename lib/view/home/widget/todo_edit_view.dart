import 'package:flutter/material.dart';
import 'package:todo_list/core/theme/theme_font_size.dart';
import 'package:todo_list/view/home/model/todo_list_model.dart';
import 'package:todo_list/view/home/todo_list_controller.dart';
import 'package:get/get.dart';

class TodoEditView extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onEdit;

  const TodoEditView({
    Key? key,
    required this.todo,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoListController todoListController =
        Get.find<TodoListController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Todo',
          style: ThemeFontSize.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextFormField(
              labelText: 'Title',
              controller: todoListController.titleController,
            ),
            const SizedBox(height: 16.0),
            buildTextFormField(
              labelText: 'Details',
              controller: todoListController.detailsController,
            ),
            const SizedBox(height: 16.0),
            buildTextFormField(
              labelText: 'Date and Time',
              controller: todoListController.dateTimeController,
              onTap: () async {
                todoListController.selectDateAndTime(
                  context,
                  todoListController.dateTimeController,
                );
              },
            ),
            const SizedBox(height: 16.0),
            buildDropdownField(
              labelText: 'Status',
              controller: todoListController.progressController,
            ),
            const SizedBox(height: 16.0),
            buildButtonSave(
              titleController: todoListController.titleController,
              detailsController: todoListController.detailsController,
              dateTimeController: todoListController.dateTimeController,
              progressController: todoListController.progressController,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String labelText,
    required TextEditingController controller,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
      onTap: onTap,
    );
  }

  Widget buildDropdownField({
    required String labelText,
    required TextEditingController controller,
  }) {
    List<String> progressOptions = ['Start', 'In Progress', 'Done'];

    return DropdownButtonFormField<String>(
      value: controller.text,
      onChanged: (value) {
        controller.text = value!;
      },
      items: progressOptions.map((progress) {
        return DropdownMenuItem<String>(
          value: progress,
          child: Text(progress),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
    );
  }

  Widget buildButtonSave({
    required TextEditingController titleController,
    required TextEditingController detailsController,
    required TextEditingController dateTimeController,
    required TextEditingController progressController,
  }) {
    return ElevatedButton(
      onPressed: () {
        final updatedTodo = Todo(
          id: '',
          title: titleController.text,
          completed: todo.completed,
          details: detailsController.text,
          dateTime: dateTimeController.text,
          progress: progressController.text,
        );
        onEdit(updatedTodo);
      },
      child: Text(
        'Save',
        style: ThemeFontSize.textTheme.bodyLarge,
      ),
    );
  }
}
