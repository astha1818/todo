import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../_utils/res/strings.dart';

import '../model/todo_dto.dart';

abstract class TodoRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<TodoDTO>> getAllTodos();
  Future<void> addTodo(TodoDTO todo);
  Future<void> updateTodo(TodoDTO todo);
  Future<void> removeTodo(TodoDTO todo);
}

class TodoRepositotyImpl extends TodoRepository {
  @override
  Future<List<TodoDTO>> getAllTodos() async {
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
    return todos;
  }

  @override
  Future<void> addTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).add(todo.toJson());
  }

  @override
  Future<void> updateTodo(TodoDTO todo) async {
    await firestore
        .collection(AppString.collectionName)
        .doc(todo.id)
        .update(todo.toJson());
  }

  @override
  Future<void> removeTodo(TodoDTO todo) async {
    await firestore.collection(AppString.collectionName).doc(todo.id).delete();
  }
}
