import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/get_posts.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required CreatePost createPost,
    required GetPosts getPosts,
  })  : _createPost = createPost,
        _getPosts = getPosts,
        super(const PostInitial());

  final CreatePost _createPost;
  final GetPosts _getPosts;

  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    emit(const CreatingPost());

    final result = await _createPost(CreatePostParams(
      title: title,
      body: body,
      userId: userId,
    ));

    result.fold(
      (failure) => emit(PostError(failure.errorMessage)),
      (sucess) => emit(const PostCreated()),
    );
  }

  Future<void> getPosts() async {
    emit(const GettingPosts());

    final result = await _getPosts();

    result.fold(
      (failure) => emit(PostError(failure.errorMessage)),
      (sucess) => emit(PostLoaded(sucess)),
    );
  }
}
