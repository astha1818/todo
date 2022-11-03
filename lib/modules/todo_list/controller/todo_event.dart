part of 'todo_bloc.dart';

abstract class TodoEvent {
  TodoEvent();
}

class TodoInitial extends TodoState {
  TodoInitial();
}

class TodoLoading extends TodoState {
  TodoLoading();
}

class TodoSuccess extends TodoState {
  List<TodoDTO>? todos;
  TodoSuccess({this.todos});
}

class TodoError extends TodoState {
  String? error;
  TodoError({this.error});
}
