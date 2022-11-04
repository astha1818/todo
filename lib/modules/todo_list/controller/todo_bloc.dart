import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/todo_dto.dart';
import '../repo/todo_repo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<GetAllTodos>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await TodoRepositotyImpl().getAllTodos();
      final updatedState = result.fold(
        (l) => state.copyWith(isLoading: false),
        (r) => state.copyWith(
          isLoading: false,
          todoList: r,
        ),
      );
      emit(updatedState);
    });

    on<AddTodos>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await TodoRepositotyImpl().addTodo(event.todo);
      final updatedState = result.fold(
        (l) => state.copyWith(
          isLoading: false,
        ),
        (r) => state.copyWith(
          isLoading: false,
          todoList: r,
        ),
      );
      emit(updatedState);
    });

    on<UpdateTodos>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await TodoRepositotyImpl().updateTodo(event.todo);
      final updatedState = result.fold(
        (l) => state.copyWith(
          isLoading: false,
        ),
        (r) => state.copyWith(
          isLoading: false,
          todoList: r,
        ),
      );
      emit(updatedState);
    });

    on<DeleteTodos>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await TodoRepositotyImpl().removeTodo(event.todo);
      final updatedState = result.fold(
        (l) => state.copyWith(
          isLoading: false,
        ),
        (r) => state.copyWith(
          isLoading: false,
          todoList: r,
        ),
      );
      emit(updatedState);
    });
  }
}
