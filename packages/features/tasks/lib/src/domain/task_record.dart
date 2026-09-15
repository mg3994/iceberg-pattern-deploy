import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Pure Dart 3 record definition representing a system Task entity.
typedef Task = ({
  String id,
  String title,
  bool isCompleted,
  IList<String> tags,
});
