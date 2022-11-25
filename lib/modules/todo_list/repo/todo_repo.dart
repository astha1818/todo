import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../_utils/helpers/response.dart';
import '../../../_utils/res/strings.dart';
import '../model/todo_dto.dart';

abstract class TodoRepository {
  Future<Response<List<TodoDTO>>> getAllTodos();
  Future<Response<Unit>> addTodo(TodoDTO todo);
  Future<Response<Unit>> updateTodo(TodoDTO todo);
  Future<Response<Unit>> removeTodo(TodoDTO todo);
}

class TodoRepositotyImpl implements TodoRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Response<List<TodoDTO>>> getAllTodos() async {
    List<TodoDTO> todos = [];
    try {
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
    } catch (e) {
      return left(Failure(
        code: 500,
        response: "Something went wrong.",
      ));
    }
  }

  @override
  Future<Response<Unit>> addTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).add(todo.toMap());
    return right(unit);
  }

  @override
  Future<Response<Unit>> updateTodo(TodoDTO todo) async {
    await firestore
        .collection(AppString.collectionName)
        .doc(todo.id)
        .update(todo.toMap());
    return right(unit);
  }

  @override
  Future<Response<Unit>> removeTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).doc(todo.id).delete();
    return right(unit);
  }
}
