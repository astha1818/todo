import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_utils/res/colors.dart';
import '../../../_utils/res/dimen.dart';
import '../../../_utils/res/strings.dart';

import '../../../_utils/helpers/validations.dart';
import '../controller/todo_bloc.dart';
import '../model/todo_dto.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _returnErrorText(String type, [id]) {
    bool isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      _addUpdateTodo(type, id);
    }
  }

  _addUpdateTodo(String type, [id]) {
    type == AppString.addType
        ? context.read<TodoBloc>().addTodo(TodoDTO(
            todoText: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            createdAt: Timestamp.now()))
        : context.read<TodoBloc>().updateTodo(
              TodoDTO(
                id: id,
                todoText: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                createdAt: Timestamp.now(),
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
            if (state is TodoLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.red,
                  ),
                ),
              );
            } else if (state is TodoInitial) {
              return const Center(child: Text(AppString.noRecordFound));
            } else if (state is TodoSuccess) {
              var todoList = state.todos;
              if (todoList!.isEmpty) {
                return const Center(child: Text(AppString.noRecordFound));
              } else {
                return _buildListView(todoList);
              }
            } else {
              return Center(
                child: Text(
                    (state as TodoError).error ?? AppString.somethingWentWrong),
              );
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
            _buildDialog(AppString.addType);
          },
        ),
      ),
    );
  }

  _buildListView(todoList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(index.toString()),
          child: _buildListViewBuilder(todoList[index]),
          onDismissed: (direction) {
            context.read<TodoBloc>().removeTodo(todoList[index]);
          },
        );
      },
      itemCount: todoList.length,
    );
  }

  _buildListViewBuilder(TodoDTO todoList) {
    return GestureDetector(
      onTap: () {
        _buildDialog(AppString.editType, todoList.id);
        _titleController.text = todoList.todoText;
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
                todoList.todoText,
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

  _buildDialog(String type, [id]) {
    showDialog(
      context: context,
      builder: (mContext) {
        return Dialog(
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
                    type == AppString.addType
                        ? AppString.addNewTodo
                        : AppString.editTodo,
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
                      _returnErrorText(type, id);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.amber),
                    ),
                    child:
                        Text(type == 'add' ? AppString.add : AppString.update),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildTitle() {
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

  _buildDescription() {
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
        return Validation.titleValidation(value);
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(250),
      ],
    );
  }
}
