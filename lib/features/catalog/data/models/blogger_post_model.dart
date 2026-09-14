import '../../domain/entities/blogger_post.dart';

final class BloggerPostModel {
  const BloggerPostModel({
    required this.blogId,
    required this.postId,
    required this.title,
    required this.content,
    required this.labels,
    required this.publishedAt,
    required this.updatedAt,
    required this.sourceUrl,
    required this.schema,
  });

  final String blogId;
  final String postId;
  final String title;
  final String content;
  final List<String> labels;
  final DateTime? publishedAt;
  final DateTime? updatedAt;
  final String? sourceUrl;
  final Map<String, dynamic>? schema;

  BloggerPost toEntity() => BloggerPost(
    blogId: blogId,
    postId: postId,
    title: title,
    content: content,
    labels: labels,
    publishedAt: publishedAt,
    updatedAt: updatedAt,
    sourceUrl: sourceUrl,
    schema: schema,
  );
}
