import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';

import '_post_repo_mock.dart';

void main() {
  late PostRepo repo;
  late CreatePost usecase;

  setUp(() {
    repo = MockPostRepo();
    usecase = CreatePost(repo: repo);
  });

  const tCreatePostParams = CreatePostParams.empty();

  test('should complete successfully the creation of a post.', () async {
    when(() => repo.createPost(
          title: any(named: 'title'),
          body: any(named: 'body'),
          userId: any(named: 'userId'),
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(tCreatePostParams);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.createPost(
        title: tCreatePostParams.title,
        body: tCreatePostParams.body,
        userId: tCreatePostParams.userId,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
