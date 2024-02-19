import 'package:todo_tdd_clen_arch/core/usecases/usecases.dart';
import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';

class GetPosts extends UsecaseWithoutParams<List<Post>> {
  final PostRepo _repo;

  GetPosts({required PostRepo repo}) : _repo = repo;

  @override
  ResultFuture<List<Post>> call() async => _repo.getPosts();
}
