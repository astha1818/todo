import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_card.dart';
import '../../../_utils/custom_widgets/custom_dialog.dart';
import '../../../_utils/custom_widgets/custom_show_dialog.dart';
import '../../../_utils/res/colors.dart';
import '../../../_utils/res/dimen.dart';
import '../../../_utils/res/strings.dart';
import '../controller/todo_bloc.dart';
import '../model/todo_dto.dart';
import 'todo_popup.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(GetAllTodos()),
      child: TodoListUI(),
    );
  }
}

class TodoListUI extends StatelessWidget {
  TodoListUI({super.key});
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text(
          AppString.todoList,
          style: TextStyle(color: AppColors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimen.size20),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.red,
                  ),
                ),
              );
            } else if (state.responseError.isNotEmpty) {
              return Text(state.responseError);
            } else {
              List<TodoDTO> todo = state.todoList;
              if (todo.isEmpty) {
                return const Center(child: Text(AppString.noRecordFound));
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(index.toString()),
                      // child: _buildListViewBuilder(todo[index]),
                      child: TodoCard(context, todo[index]),
                      onDismissed: (direction) {
                        context.read<TodoBloc>().add(
                              DeleteTodo(
                                todo[index],
                              ),
                            );
                      },
                    );
                  },
                  itemCount: todo.length,
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.amber,
        onPressed: () {},
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _buildDialog(context, Type.add);
          },
        ),
      ),
    );
  }

  _buildDialog(BuildContext context, Type type) {
    CustomShowDialog.showDialogBox(
      context: context,
      builder: CustomDialog.showDialogBox(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimen.size20)),
        child: TodoPopup(
          mContext: context,
          type: type,
          titleController: _titleController,
          descriptionController: _descriptionController,
        ),
      ),
    );
  }
}
