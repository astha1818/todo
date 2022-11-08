part of 'todo_bloc.dart';

abstract class TodoEvent {
  const TodoEvent();
}

class GetAllTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  TodoDTO todo;
  AddTodo(
    this.todo,
  );
}

class UpdateTodo extends TodoEvent {
  TodoDTO todo;
  UpdateTodo(
    this.todo,
  );
}

class DeleteTodo extends TodoEvent {
  TodoDTO todo;
  DeleteTodo(
    this.todo,
  );
}
