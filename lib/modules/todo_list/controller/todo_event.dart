part of 'todo_bloc.dart';

abstract class TodoEvent {
  const TodoEvent();
}

class GetAllTodos extends TodoEvent {}

class AddTodos extends TodoEvent {
  TodoDTO todo;
  AddTodos(
    this.todo,
  );
}

class UpdateTodos extends TodoEvent {
  TodoDTO todo;
  UpdateTodos(
    this.todo,
  );
}

class DeleteTodos extends TodoEvent {
  TodoDTO todo;
  DeleteTodos(
    this.todo,
  );
}
