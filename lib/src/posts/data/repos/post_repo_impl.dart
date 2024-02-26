import 'package:dartz/dartz.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';
import 'package:todo_tdd_clen_arch/core/errors/failure.dart';
import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/datasources/post_remote_datasource.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';

class PostRepoImpl implements PostRepo {
  final PostRemoteDataSource _datasource;

  PostRepoImpl({required PostRemoteDataSource datasource})
      : _datasource = datasource;

  @override
  ResultVoid createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      await _datasource.createPost(
        title: title,
        body: body,
        userId: userId,
      );

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Post>> getPosts() async {
    try {
      return Right(await _datasource.getPosts());
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
