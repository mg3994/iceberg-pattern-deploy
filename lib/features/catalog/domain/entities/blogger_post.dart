import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// Pure Dart 3 Record Typedef representation of BloggerPost entity.
typedef BloggerPost = ({
  String blogId,
  String postId,
  String title,
  String content,
  IList<String> labels,
  DateTime? publishedAt,
  DateTime? updatedAt,
  String? sourceUrl,
  IMap<String, dynamic>? schema,
});
