import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/theme/theme_color.dart';
import 'package:todo_list/core/theme/theme_font.dart';
import 'package:todo_list/core/theme/theme_font_size.dart';
import 'package:todo_list/view/home/model/todo_list_model.dart';
import 'package:todo_list/view/home/todo_list_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/view/home/widget/todo_edit_view.dart';

class TodoListView extends StatelessWidget {
  final TodoListController todoListController = Get.put(TodoListController());

  TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: ThemeFontSize.textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildSearchField(),
              const SizedBox(height: 16),
              GetBuilder<TodoListController>(
                builder: (controller) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = controller.filteredTodos[index];
                      return buildCardList(todo, index);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        todoListController.clearTextControllers();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Create Todo',
                style: ThemeFontSize.textTheme.titleLarge,
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTitleField(),
                    const SizedBox(height: 16.0),
                    buildDetailsField(),
                    const SizedBox(height: 16.0),
                    buildDateTimeField(context),
                    const SizedBox(height: 16.0),
                    buildDropdownButton(),
                  ],
                ),
              ),
              actions: [
                buildSaveButton(context),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget buildCardList(Todo todo, int index) {
    return Slidable(
      key: ValueKey<int>(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            todoListController.removeTodo(index);
          },
        ),
        children: buildIconButtonEditDelete(todo, index),
      ),
      child: Card(
        elevation: 3.0,
        color: getCardColor(todo.progress),
        child: ListTile(
          title: Text(
            todo.title,
            style: TextStyle(
              color: ThemeColor.surface,
              decoration: todo.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              fontFamily: ThemeFont.defaultFontFamily,
            ),
          ),
          subtitle: buildSubTitle(todo),
          leading: buildProgressImage(todo.progress),
        ),
      ),
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: todoListController.titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
      style: ThemeFontSize.textTheme.titleMedium,
    );
  }

  Widget buildDetailsField() {
    return TextFormField(
      controller: todoListController.detailsController,
      decoration: InputDecoration(
        labelText: 'Details',
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
      style: ThemeFontSize.textTheme.titleMedium,
    );
  }

  Widget buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        todoListController.addTodoWithDetails(
          id: '',
          title: todoListController.titleController.text,
          details: todoListController.detailsController.text,
          dateTime: todoListController.dateTimeController.text,
          progress: todoListController.selectedProgress,
        );
        Navigator.of(context).pop();
      },
      child: Text(
        'Save',
        style: ThemeFontSize.textTheme.bodyMedium,
      ),
    );
  }

  Widget buildDropdownButton() {
    return DropdownButtonFormField<String>(
      value: todoListController.selectedProgress,
      style: ThemeFontSize.textTheme.titleMedium,
      onChanged: (value) {
        todoListController.selectedProgress = value!;
      },
      items: ['Start', 'In Progress', 'Done'].map((progress) {
        return DropdownMenuItem<String>(
          value: progress,
          child: Text(
            progress,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
              fontFamily: ThemeFont.defaultFontFamily,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Status',
        labelStyle: ThemeFontSize.textTheme.titleMedium,
      ),
    );
  }

  Widget buildDateTimeField(BuildContext context) {
    return TextFormField(
      controller: todoListController.dateTimeController,
      decoration: InputDecoration(
        labelText: 'Date and Time',
        labelStyle: ThemeFontSize.textTheme.titleMedium,
        prefixIcon: const Icon(
          Icons.calendar_today,
          size: 16,
        ),
      ),
      style: ThemeFontSize.textTheme.titleMedium,
      onTap: () async {
        BuildContext currentContext = context;

        DateTime? pickedDate = await showDatePicker(
          context: currentContext,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          // ignore: use_build_context_synchronously
          TimeOfDay? pickedTime = await showTimePicker(
            context: currentContext,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            // ignore: use_build_context_synchronously
            todoListController.selectDateAndTime(
              currentContext,
              todoListController.dateTimeController,
            );
          }
        }
      },
    );
  }

  Widget buildSearchField() {
    return TextField(
      onChanged: (value) {
        todoListController.filterTodos(value);
      },
      decoration: InputDecoration(
        labelText: 'Search',
        prefixIcon: const Icon(Icons.search),
        errorStyle: ThemeFontSize.textTheme.headlineMedium,
      ),
    );
  }

  List<Widget> buildIconButtonEditDelete(Todo todo, int index) {
    return [
      SlidableAction(
        onPressed: (BuildContext context) {
          Get.to(() => TodoEditView(
                todo: todo,
                onEdit: (updatedTodo) {
                  todoListController.editTodo(index, updatedTodo);
                  Get.back();
                },
              ));
        },
        backgroundColor: ThemeColor.startColor,
        foregroundColor: ThemeColor.surface,
        icon: Icons.edit,
      ),
      SlidableAction(
        onPressed: (BuildContext context) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to delete this item?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        fontFamily: ThemeFont.defaultFontFamily,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      todoListController.removeTodo(index);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        fontFamily: ThemeFont.defaultFontFamily,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: ThemeColor.errorColor,
        foregroundColor: ThemeColor.surface,
        icon: Icons.delete,
      ),
    ];
  }

  Widget buildSubTitle(Todo todo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        if (todo.details.isNotEmpty)
          Text(
            'Details: ${todo.details}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
              fontFamily: ThemeFont.defaultFontFamily,
              color: ThemeColor.surface,
            ),
          ),
        if (todo.dateTime.isNotEmpty)
          Text(
            'Date and Time: ${todo.dateTime}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
              fontFamily: ThemeFont.defaultFontFamily,
              color: ThemeColor.surface,
            ),
          ),
        if (todo.progress.isNotEmpty)
          Text(
            'Status: ${todo.progress}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
              fontFamily: ThemeFont.defaultFontFamily,
              color: ThemeColor.surface,
            ),
          ),
      ],
    );
  }

  Widget buildProgressImage(String progress) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: ThemeColor.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getImageWidget(progress),
      ),
    );
  }

  Widget getImageWidget(String progress) {
    return Image.asset(
      getImagePath(progress),
      fit: BoxFit.fill,
      alignment: Alignment.center,
    );
  }

  String getImagePath(String progress) {
    switch (progress) {
      case 'In Progress':
        return 'assets/images/in_progress.png';
      case 'Start':
        return 'assets/images/start.png';
      default:
        return 'assets/images/done.png';
    }
  }

  Color getCardColor(String progress) {
    switch (progress) {
      case 'Start':
        return Colors.blue;
      case 'In Progress':
        return Colors.yellow;
      case 'Done':
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}
