import 'dart:convert';

import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
  });

  const PostModel.empty()
      : this(body: '_empty', title: '_empty', userId: 1, id: 1);

  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromMap(DataMap map) {
    return PostModel(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) {
    return PostModel.fromMap(json.decode(source) as DataMap);
  }
}
