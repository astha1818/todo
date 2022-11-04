import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../_utils/res/strings.dart';

class TodoDTO {
  String? id;
  final String title;
  final String description;
  final Timestamp createdAt;

  TodoDTO({
    required this.title,
    required this.description,
    required this.createdAt,
    this.id,
  });

  TodoDTO copyWith({
    String? id,
    String? title,
    String? description,
    Timestamp? createdAt,
  }) {
    return TodoDTO(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory TodoDTO.fromMap(Map<String, dynamic> map) {
    return TodoDTO(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: Timestamp.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoDTO.fromJson(Map<String, dynamic> json) => TodoDTO(
        title: json[AppString.title],
        description: json[AppString.description],
        createdAt: json[AppString.createdAt],
      );

  @override
  String toString() {
    return 'TodoDTO(id: $id, title: $title, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TodoDTO other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
