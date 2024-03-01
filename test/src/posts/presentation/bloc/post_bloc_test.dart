import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/core/errors/failure.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/create_post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/usecases/get_posts.dart';
import 'package:todo_tdd_clen_arch/src/posts/presentation/bloc/post_bloc.dart';

class MockGetPosts extends Mock implements GetPosts {}

class MockCreatePost extends Mock implements CreatePost {}

void main() {
  late CreatePost createPost;
  late GetPosts getPosts;
  late PostBloc bloc;

  const tCreatePost = CreatePostParams.empty();
  const tApiFailure = ApiFailure(message: 'message', statusCode: 400);

  setUp(() {
    createPost = MockCreatePost();
    getPosts = MockGetPosts();
    bloc = PostBloc(createPost: createPost, getPosts: getPosts);
    registerFallbackValue(tCreatePost);
  });

  group('createPost', () {
    blocTest<PostBloc, PostState>(
      'should emit [CreatingPost, PostCreated] when successful',
      build: () {
        when(() => createPost(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreatePostEvent(
        userId: tCreatePost.userId,
        title: tCreatePost.title,
        body: tCreatePost.body,
      )),
      expect: () => const <PostState>[CreatingPost(), PostCreated()],
      verify: (_) {
        verify(() => createPost(tCreatePost)).called(1);
        verifyNoMoreInteractions(createPost);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [CreatingPost, PostError] when unsuccessful',
      build: () {
        when(() => createPost(any())).thenAnswer(
          (_) async => const Left(tApiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreatePostEvent(
        userId: tCreatePost.userId,
        title: tCreatePost.title,
        body: tCreatePost.body,
      )),
      expect: () => <PostState>[
        const CreatingPost(),
        PostError(tApiFailure.errorMessage)
      ],
      verify: (_) {
        verify(() => createPost(tCreatePost)).called(1);
        verifyNoMoreInteractions(createPost);
      },
    );
  });
  group('getPosts', () {
    blocTest<PostBloc, PostState>(
      'should emit [GettingPosts, PostLoaded] when successful',
      build: () {
        when(() => getPosts()).thenAnswer(
          (_) async => const Right([]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetPostsEvent()),
      expect: () => const <PostState>[GettingPosts(), PostLoaded([])],
      verify: (_) {
        verify(() => getPosts()).called(1);
        verifyNoMoreInteractions(getPosts);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [GettingPosts, PostError] when unsuccessful',
      build: () {
        when(() => getPosts()).thenAnswer(
          (_) async => const Left(tApiFailure),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetPostsEvent()),
      expect: () => <PostState>[
        const GettingPosts(),
        PostError(tApiFailure.errorMessage)
      ],
      verify: (_) {
        verify(() => getPosts()).called(1);
        verifyNoMoreInteractions(getPosts);
      },
    );
  });
}
