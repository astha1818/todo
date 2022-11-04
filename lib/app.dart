import 'package:flutter/material.dart';

import '_utils/helpers/routes.dart';
import '_utils/res/strings.dart';

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
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.todoList,
      debugShowCheckedModeBanner: false,
    );
  }
}
