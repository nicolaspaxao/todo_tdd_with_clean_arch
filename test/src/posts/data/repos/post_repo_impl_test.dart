import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';
import 'package:todo_tdd_clen_arch/core/errors/failure.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/datasources/post_remote_datasource.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/repos/post_repo_impl.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late PostRemoteDataSource datasource;
  late PostRepoImpl repo;

  setUp(() {
    datasource = MockPostRemoteDataSource();
    repo = PostRepoImpl(datasource: datasource);
  });

  const tCreatePostModel = CreatePostParams.empty();
  const tException = ApiException(message: '', statusCode: 404);
  const tList = [PostModel.empty()];

  group('creatPost', () {
    test(
      'should call the [PostRemoteDataSource.createPost] and complete sucessfully'
      'when the call to remote is success',
      () async {
        when(() => datasource.createPost(
              title: any(named: 'title'),
              body: any(named: 'body'),
              userId: any(named: 'userId'),
            )).thenAnswer(
          (_) async => const Right(null),
        );

        final result = await repo.createPost(
          title: tCreatePostModel.title,
          body: tCreatePostModel.body,
          userId: tCreatePostModel.userId,
        );

        expect(result, equals(const Right(null)));

        verify(() => datasource.createPost(
              title: tCreatePostModel.title,
              body: tCreatePostModel.body,
              userId: tCreatePostModel.userId,
            )).called(1);

        verifyNoMoreInteractions(datasource);
      },
    );

    test(
      'should return a [ApiFailure] when the call to the remote source is unsucessfull',
      () async {
        when(() => datasource.createPost(
              title: any(named: 'title'),
              body: any(named: 'body'),
              userId: any(named: 'userId'),
            )).thenThrow(tException);

        final result = await repo.createPost(
          title: tCreatePostModel.title,
          body: tCreatePostModel.body,
          userId: tCreatePostModel.userId,
        );

        expect(result, equals(Left(ApiFailure.fromException(tException))));

        verify(() => datasource.createPost(
              title: tCreatePostModel.title,
              body: tCreatePostModel.body,
              userId: tCreatePostModel.userId,
            )).called(1);

        verifyNoMoreInteractions(datasource);
      },
    );
  });

  group('getPosts', () {
    test(
      'should call the [PostRemoteDataSource.getPosts()] and return a'
      '[List<PostModel>] when call to the remote is sucessful',
      () async {
        when(() => datasource.getPosts()).thenAnswer((_) async => tList);

        final result = await repo.getPosts();

        expect(result, equals(const Right(tList)));
        verify(() => datasource.getPosts()).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test(
      'should return a [ApiFailure] when the call to the remote source is unsucessfull',
      () async {
        when(() => datasource.getPosts()).thenThrow(tException);

        final result = await repo.getPosts();

        expect(result, equals(Left(ApiFailure.fromException(tException))));
        verify(() => datasource.getPosts()).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
  });
}
