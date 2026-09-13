import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Pure Dart 3 Record Typedef representation of a domain Task.
typedef Task = ({
  String id,
  String title,
  bool isCompleted,
  IList<String> tags,
});
