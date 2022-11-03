import 'package:flutter/material.dart';

import '../../modules/todo_list/view/todo_list.dart';

class AppRoutes {
  static const String todoList = '/todoList';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      todoList: ((context) => const TodoList()),
    };
  }
}
