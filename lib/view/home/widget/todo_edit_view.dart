import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/theme/theme_font_size.dart';
import 'package:todo_list/view/home/model/todo_list_model.dart';
import 'package:todo_list/view/home/todo_list_controller.dart';

class TodoEditView extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onEdit;

  final List<String> progressOptions = ['Start', 'In Progress', 'Done'];
  final TodoListController todoListController = Get.put(TodoListController());

  TodoEditView({Key? key, required this.todo, required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: todo.title);
    final TextEditingController detailsController =
        TextEditingController(text: todo.details);
    final TextEditingController dateTimeController =
        TextEditingController(text: todo.dateTime);
    final TextEditingController progressController =
        TextEditingController(text: todo.progress);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Todo',
          style: ThemeFontSize.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: ThemeFontSize.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  labelStyle: ThemeFontSize.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: dateTimeController,
                decoration: InputDecoration(
                  labelText: 'Date and Time',
                  labelStyle: ThemeFontSize.textTheme.titleMedium,
                ),
                onTap: () async {
                  selectDateAndTime(context, dateTimeController);
                },
              ),
              const SizedBox(height: 16.0),
              buildDropdownField(progressController),
              const SizedBox(height: 16.0),
              buildButtonSave(
                context,
                titleController,
                detailsController,
                dateTimeController,
                progressController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(TextEditingController progressController) {
    return DropdownButtonFormField<String>(
      value: progressController.text,
      onChanged: (value) {
        progressController.text = value!;
      },
      items: progressOptions.map((progress) {
        return DropdownMenuItem<String>(
          value: progress,
          child: Text(progress),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Status',
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
    );
  }

  Widget buildButtonSave(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController detailsController,
    TextEditingController dateTimeController,
    TextEditingController progressController,
  ) {
    return ElevatedButton(
      // onPressed: () {
      //   final updatedTodo = Todo(
      //     title: titleController.text,
      //     completed: todo.completed,
      //     details: detailsController.text,
      //     dateTime: dateTimeController.text,
      //     progress: progressController.text,
      //   );
      //   onEdit(updatedTodo);
      // },
      onPressed: () {
        todoListController.addTodoWithDetails(
          title: titleController.text.trim(),
          details: detailsController.text,
          dateTime: dateTimeController.text,
          progress: progressController.text,
        );
        Navigator.of(context).pop();
      },
      child: Text(
        'Save',
        style: ThemeFontSize.textTheme.bodyLarge,
      ),
    );
  }

  Future<void> selectDateAndTime(
    BuildContext context,
    TextEditingController dateTimeController,
  ) async {
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
        dateTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm a').format(selectedDateTime);
      }
    }
  }
}
