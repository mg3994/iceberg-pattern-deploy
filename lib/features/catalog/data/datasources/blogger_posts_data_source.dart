import '../../domain/entities/catalog_filter.dart';
import '../models/blogger_post_model.dart';

abstract interface class BloggerPostsDataSource {
  Future<List<BloggerPostModel>> fetchPosts(CatalogFilter filter);

  Future<BloggerPostModel?> fetchPost({required String postId});
}
