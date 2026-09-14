final class SchemaReference {
  const SchemaReference({this.blogId, this.postId, this.url});

  final String? blogId;
  final String? postId;
  final String? url;

  bool get isBloggerPost => blogId != null && postId != null;
}
