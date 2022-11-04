import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/_utils/custom_widgets/custom_dialog.dart';
import 'package:todo/_utils/custom_widgets/custom_show_dialog.dart';
import '../../../_utils/res/colors.dart';
import '../../../_utils/res/dimen.dart';
import '../../../_utils/res/strings.dart';
import '../../../_utils/helpers/validations.dart';
import '../controller/todo_bloc.dart';
import '../model/todo_dto.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc()..add(GetAllTodos()),
      child: const TodoListUI(),
    );
  }
}

class TodoListUI extends StatefulWidget {
  const TodoListUI({super.key});

  @override
  State<TodoListUI> createState() => _TodoListState();
}

class _TodoListState extends State<TodoListUI> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _returnErrorText(String? id) {
    bool isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      _addUpdateTodo(id);
    }
  }

  void _addUpdateTodo(String? id) {
    id == null
        ? context.read<TodoBloc>().add(
              AddTodos(
                TodoDTO(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  createdAt: Timestamp.now(),
                ),
              ),
            )
        : context.read<TodoBloc>().add(
              UpdateTodos(
                TodoDTO(
                  id: id,
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  createdAt: Timestamp.now(),
                ),
              ),
            );
    _titleController.text = '';
    _descriptionController.text = '';
    Navigator.pop(context, true);
  }

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
            } else {
              List<TodoDTO> todo = state.todoList;
              if (todo.isEmpty) {
                return const Center(child: Text(AppString.noRecordFound));
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(index.toString()),
                      child: _buildListViewBuilder(todo[index]),
                      onDismissed: (direction) {
                        context.read<TodoBloc>().add(
                              DeleteTodos(
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
            _buildDialog(Type.add);
          },
        ),
      ),
    );
  }

  Widget _buildListViewBuilder(TodoDTO todoList) {
    return GestureDetector(
      onTap: () {
        _buildDialog(Type.edit, todoList.id);
        _titleController.text = todoList.title;
        _descriptionController.text = todoList.description;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimen.size10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimen.size10),
          color: AppColors.white,
          boxShadow: const [
            BoxShadow(color: AppColors.grey, spreadRadius: 1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimen.size10),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                todoList.title,
                style: const TextStyle(
                  fontSize: AppDimen.size16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: AppDimen.size10,
              ),
              Text(
                todoList.description,
                style: const TextStyle(
                  fontSize: AppDimen.size14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDialog(Type type, [id]) {
    CustomShowDialog.showDialogBox(
      context: context,
      builder: CustomDialog.showDialogBox(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimen.size20)),
        child: Padding(
          padding: const EdgeInsets.all(AppDimen.size20),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  type == Type.add ? AppString.addNewTodo : AppString.editTodo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppDimen.size18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimen.size20),
                _buildTitle(),
                const SizedBox(height: AppDimen.size20),
                _buildDescription(),
                const SizedBox(height: AppDimen.size20),
                ElevatedButton(
                  onPressed: () {
                    _returnErrorText(id);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.amber),
                  ),
                  child:
                      Text(type == Type.add ? AppString.add : AppString.update),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontSize: AppDimen.size14,
      ),
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: AppString.title,
        labelStyle: TextStyle(
          fontSize: AppDimen.size16,
          color: AppColors.black,
        ),
        hintText: AppString.enterTitle,
        hintStyle: TextStyle(
          fontSize: AppDimen.size16,
          color: AppColors.black,
        ),
      ),
      textInputAction: TextInputAction.next,
      maxLines: 2,
      minLines: 1,
      maxLength: 50,
      validator: (value) {
        return Validation.titleValidation(value);
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontSize: AppDimen.size14,
      ),
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: AppString.description,
        labelStyle: TextStyle(
          fontSize: AppDimen.size16,
          color: AppColors.black,
        ),
        hintText: AppString.enterDescription,
        hintStyle: TextStyle(
          fontSize: AppDimen.size16,
          color: AppColors.black,
        ),
      ),
      textInputAction: TextInputAction.done,
      maxLines: 5,
      minLines: 1,
      maxLength: 250,
      validator: (value) {
        return Validation.descriptionValidation(value);
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(250),
      ],
    );
  }
}
