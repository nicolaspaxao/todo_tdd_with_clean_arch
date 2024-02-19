import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post.empty() : this(body: '_empty', title: '_empty', userId: 1, id: 1);

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [userId, id, title, body];
}
