import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../_utils/helpers/response.dart';
import '../../../_utils/res/strings.dart';
import '../model/todo_dto.dart';

abstract class TodoRepository {
  Future<Response<List<TodoDTO>>> getAllTodos();
  Future<Response<List<TodoDTO>>> addTodo(TodoDTO todo);
  Future<Response<List<TodoDTO>>> updateTodo(TodoDTO todo);
  Future<Response<List<TodoDTO>>> removeTodo(TodoDTO todo);
}

class TodoRepositotyImpl implements TodoRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Response<List<TodoDTO>>> getAllTodos() async {
    List<TodoDTO> todos = [];
    final results = await firestore
        .collection(AppString.collectionName)
        .orderBy(AppString.createdAt)
        .get();
    for (var snapshot in results.docs) {
      TodoDTO newTodo = TodoDTO.fromJson(snapshot.data());
      newTodo.id = snapshot.id;
      todos.add(newTodo);
    }
    return right(todos);
  }

  @override
  Future<Response<List<TodoDTO>>> addTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).add(todo.toMap());
    getAllTodos();
    return getAllTodos();
  }

  @override
  Future<Response<List<TodoDTO>>> updateTodo(TodoDTO todo) async {
    await firestore
        .collection(AppString.collectionName)
        .doc(todo.id)
        .update(todo.toMap());
    getAllTodos();
    return getAllTodos();
  }

  @override
  Future<Response<List<TodoDTO>>> removeTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).doc(todo.id).delete();

    getAllTodos();
    return getAllTodos();
  }
}
