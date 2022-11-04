import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../_utils/res/strings.dart';

TodoDTO todoFromJson(String str) => TodoDTO.fromJson(json.decode(str));

String todoToJson(TodoDTO data) => json.encode(data.toJson());

class TodoDTO {
  String? id;
  final String title, description;
  final Timestamp createdAt;
  TodoDTO(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.id});

  factory TodoDTO.fromJson(Map<String, dynamic> json) => TodoDTO(
        title: json[AppString.title],
        description: json[AppString.description],
        createdAt: json[AppString.createdAt],
      );

  Map<String, dynamic> toJson() => {
        AppString.title: title,
        AppString.description: description,
        AppString.createdAt: createdAt,
      };
}
