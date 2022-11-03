part of 'todo_bloc.dart';

class TodoState {
  final List<TodoDTO> getAllTodos;
  TodoState({
    this.getAllTodos = const [],
  });

  TodoState copyWith({
    List<TodoDTO>? getAllTodos,
  }) {
    return TodoState(
      getAllTodos: getAllTodos ?? this.getAllTodos,
    );
  }

  @override
  String toString() {
    return 'TodoState(getAllTodos: $getAllTodos,)';
  }
}
