import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../_utils/res/strings.dart';

TodoDTO todoFromJson(String str) => TodoDTO.fromJson(json.decode(str));

String todoToJson(TodoDTO data) => json.encode(data.toJson());

class TodoDTO {
  String? id;
  final String todoText, description;
  final Timestamp createdAt;
  TodoDTO(
      {required this.todoText,
      required this.description,
      required this.createdAt,
      this.id});

  factory TodoDTO.fromJson(Map<String, dynamic> json) => TodoDTO(
        todoText: json[AppString.todoText],
        description: json[AppString.description],
        createdAt: json[AppString.createdAt],
      );

  Map<String, dynamic> toJson() => {
        AppString.todoText: todoText,
        AppString.description: description,
        AppString.createdAt: createdAt,
      };
}
