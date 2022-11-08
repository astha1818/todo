import 'package:flutter/material.dart';
import '../../../_utils/res/strings.dart';
import 'todo_popup.dart';

import '../../../_utils/custom_widgets/custom_dialog.dart';
import '../../../_utils/custom_widgets/custom_show_dialog.dart';
import '../../../_utils/res/colors.dart';
import '../../../_utils/res/dimen.dart';
import '../model/todo_dto.dart';

class TodoListView extends StatelessWidget {
  TodoListView(this.mContext, this.todoList, {super.key});
  final BuildContext mContext;
  final TodoDTO todoList;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _buildDialog(context, Type.edit, todoList.id);
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

  _buildDialog(BuildContext context, Type type, [id]) {
    CustomShowDialog.showDialogBox(
      context: context,
      builder: CustomDialog.showDialogBox(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimen.size20)),
        child: TodoPopup(
          mContext: mContext,
          type: type,
          id: id,
          titleController: _titleController,
          descriptionController: _descriptionController,
        ),
      ),
    );
  }
}
