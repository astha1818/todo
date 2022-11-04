import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_utils/helpers/global.dart';

import '../model/todo_dto.dart';
import '../repo/todo_repo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Cubit<TodoState> {
  TodoBloc({TodoRepository? todoRepository})
      : _todoRepository = todoRepository ?? TodoRepositotyImpl(),
        super(TodoInitial());

  final TodoRepository _todoRepository;

  Future<void> getAllTodo() async {
    emit(TodoLoading());
    final results = await _todoRepository.getAllTodos();
    emit(TodoSuccess(todos: results));
    printDebug('Fetched Successful');
  }

  Future<void> addTodo(TodoDTO todo) async {
    if (todo.title.isEmpty) return;
    emit(TodoLoading());
    await _todoRepository.addTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(TodoSuccess(todos: results));
    printDebug('Added Successful');
  }

  Future<void> updateTodo(TodoDTO todo) async {
    if (todo.title.isEmpty) return;
    emit(TodoLoading());
    await _todoRepository.updateTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(TodoSuccess(todos: results));
    printDebug('Updated Successful');
  }

  Future<void> removeTodo(TodoDTO todo) async {
    emit(TodoLoading());
    await _todoRepository.removeTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(TodoSuccess(todos: results));
    printDebug('Deleted Successful');
  }
}
