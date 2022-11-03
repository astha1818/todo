import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_utils/res/strings.dart';
import 'modules/todo_list/controller/todo_bloc.dart';
import 'modules/todo_list/view/todo_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppString.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // routes: AppRoutes.getRoutes(),
      // initialRoute: AppRoutes.todoList,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoBloc()..getAllTodo(),
        child: const TodoList(),
      ),
    );
  }
}
