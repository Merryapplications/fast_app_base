import 'package:fast_app_base/data/memory/todo_data_change_notifier.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:fast_app_base/screen/main/write/d_write_todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoData extends GetxController {
  final TodoDataChangeNotifier todoDataChangeNotifier = TodoDataChangeNotifier();

  int get newId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void addTodo(BuildContext context) async {
    final result = await WriteTodoBottomSheet().show();
    result?.runIfSuccess((data) {
      final newTodo = Todo(
        id: newId,
        title: data.title,
        dueDate: data.dueDate,
      );
      todoDataChangeNotifier.addTodo(newTodo);
    });
  }

  void changeTodoStatus(Todo todo) async {
    switch (todo.status) {
      case TodoStatus.complete:
        final result = await ConfirmDialog('다시 처음 상태로 변경하시겠어요?').show();
        result?.runIfSuccess((data) {
          todo.status = TodoStatus.incomplete;
        });
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
    }
    todoDataChangeNotifier.notify();
  }

  editTodo(Todo todo) async {
    final result = await WriteTodoBottomSheet(todoForEdit: todo).show();
    result?.runIfSuccess((data) {
      todo.modifyTime = DateTime.now();
      todo.title = data.title;
      todo.dueDate = data.dueDate;
      todoDataChangeNotifier.notify();
    });
  }

  void removeTodo(Todo todo) {
    todoDataChangeNotifier.remove(todo);
  }
}

mixin class TodoDataProvider {
  late final TodoData todoData = Get.find();
}