import 'package:flutter/foundation.dart';

/// Clean Domain Entity representing a Task item.
@immutable
class Task {
  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.tags = const [],
  });

  final String id;
  final String title;
  final bool isCompleted;
  final List<String> tags;

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted, Object.hashAll(tags));
}
