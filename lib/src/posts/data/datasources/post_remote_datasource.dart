import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();

  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  });
}
