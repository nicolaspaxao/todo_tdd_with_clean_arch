import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/repos/post_repo.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/get_posts.dart';

import '_post_repo_mock.dart';

void main() {
  late PostRepo repo;
  late GetPosts usecase;

  setUp(() {
    repo = MockPostRepo();
    usecase = GetPosts(repo: repo);
  });

  const tResult = [Post.empty()];

  test('should return [List<Posts>] when successfull', () async {
    when(() => repo.getPosts()).thenAnswer((_) async => const Right(tResult));

    final result = await usecase();

    expect(result.length(), equals(1));
    expect(result, equals(const Right<dynamic, List<Post>>(tResult)));

    verify(() => repo.getPosts()).called(1);

    verifyNoMoreInteractions(repo);
  });
}
