part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {
  const PostInitial();
}

final class CreatingPost extends PostState {
  const CreatingPost();
}

final class GettingPosts extends PostState {
  const GettingPosts();
}

final class PostCreated extends PostState {
  const PostCreated();
}

final class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded(this.posts);

  @override
  List<Object> get props => posts.map((e) => e.id).toList();
}

final class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}
