import 'package:equatable/equatable.dart';

import 'package:todo_tdd_clen_arch/core/usecases/usecases.dart';
import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';

class CreatePost extends UsecaseWithParams<void, CreatePostParams> {
  final PostRepo _repo;

  CreatePost({required PostRepo repo}) : _repo = repo;

  @override
  ResultFuture<void> call(CreatePostParams params) {
    return _repo.createPost(
      title: params.title,
      body: params.body,
      userId: params.userId,
    );
  }
}

class CreatePostParams extends Equatable {
  final String title;
  final String body;
  final int userId;

  const CreatePostParams.empty()
      : this(body: '_empty', title: '_empty', userId: 1);

  const CreatePostParams(
      {required this.title, required this.body, required this.userId});

  @override
  List<Object> get props => [title, body, userId];
}
