import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';

abstract class PostRepo {
  ResultFuture<List<Post>> getPosts();

  ResultVoid createPost({
    required String title,
    required String body,
    required int userId,
  });
}
