part of 'todo_bloc.dart';

class TodoState {
  final List<TodoDTO> todoList;
  final bool isLoading;
  final String responseError;

  TodoState({
    this.todoList = const [],
    this.isLoading = false,
    this.responseError = "",
  });

  TodoState copyWith({
    List<TodoDTO>? todoList,
    bool? isLoading,
    String? responseError,
  }) {
    return TodoState(
      todoList: todoList ?? this.todoList,
      isLoading: isLoading ?? this.isLoading,
      responseError: responseError ?? this.responseError,
    );
  }

  @override
  String toString() {
    return 'TodoState(todoList: $todoList, isLoading: $isLoading, responseError: $responseError,)';
  }
}
