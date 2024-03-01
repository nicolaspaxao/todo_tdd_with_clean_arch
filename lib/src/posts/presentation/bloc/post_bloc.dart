import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/get_posts.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required CreatePost createPost,
    required GetPosts getPosts,
  })  : _createPost = createPost,
        _getPosts = getPosts,
        super(const PostInitial()) {
    on<CreatePostEvent>(_createPostHandle);
    on<GetPostsEvent>(_getPostsHandle);
  }

  final CreatePost _createPost;
  final GetPosts _getPosts;

  Future<void> _createPostHandle(
    CreatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const CreatingPost());

    final result = await _createPost(CreatePostParams(
      title: event.title,
      body: event.body,
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(PostError(failure.errorMessage)),
      (sucess) => emit(const PostCreated()),
    );
  }

  Future<void> _getPostsHandle(
    GetPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const GettingPosts());

    final result = await _getPosts();

    result.fold(
      (failure) => emit(PostError(failure.errorMessage)),
      (sucess) => emit(PostLoaded(sucess)),
    );
  }
}
