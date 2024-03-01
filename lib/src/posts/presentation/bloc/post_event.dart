part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class CreatePostEvent extends PostEvent {
  final int userId;
  final String title;
  final String body;

  const CreatePostEvent({
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [userId, title, body];
}

final class GetPostsEvent extends PostEvent {
  const GetPostsEvent();
}
