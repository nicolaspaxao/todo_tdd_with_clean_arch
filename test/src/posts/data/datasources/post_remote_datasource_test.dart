import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';
import 'package:todo_tdd_clen_arch/core/utils/constants.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/datasources/post_remote_datasource.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late PostRemoteDataSourceImpl dataSource;

  setUp(() {
    client = MockClient();
    dataSource = PostRemoteDataSourceImpl(client: client);
    registerFallbackValue(Uri());
  });

  const tBody = 'tBody';
  const tTitle = 'tTitle';
  const tUserId = 1;

  final tResponse = [const PostModel.empty().toMap()];

  group('getPosts', () {
    test(
      'should return a list of PostModel when the call to Dio is successful',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode(tResponse), 200),
        );

        final result = await dataSource.getPosts();

        expect(result, isA<List<PostModel>>());
        expect(result.length, equals(1));

        verify(() => client.get(Uri.parse('$kBaseUrl/posts'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw an ApiException when the call to Dio is unsuccessful',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        final call = dataSource.getPosts;

        expect(() => call(), throwsA(isA<ApiException>()));
        verify(() => client.get(Uri.parse('$kBaseUrl/posts'))).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });

  group('createPost', () {
    test(
      'should perform a POST request with the given parameters',
      () async {
        when(
          () => client.post(
            any(),
            body: any(named: 'body'),
            headers: {'Content-type': 'application/json; charset=UTF-8'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Sucess', 200),
        );

        await dataSource.createPost(
          title: tTitle,
          body: tBody,
          userId: tUserId,
        );

        verify(
          () => client.post(
            Uri.parse('$kBaseUrl/posts'),
            body: jsonEncode(
              {'title': tTitle, 'body': tBody, 'userId': tUserId},
            ),
            headers: {'Content-type': 'application/json; charset=UTF-8'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw an ApiException when the call to Dio is unsuccessful',
      () async {
        when(() => client.post(
              any(),
              body: any(named: 'body'),
              headers: {'Content-type': 'application/json; charset=UTF-8'},
            )).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.createPost;

        expect(
          () => call(title: tTitle, body: tBody, userId: tUserId),
          throwsA(
            const ApiException(
              message: 'Not Found',
              statusCode: 404,
            ),
          ),
        );

        verify(
          () => client.post(
            Uri.parse('$kBaseUrl/posts'),
            body: jsonEncode(
              {'title': tTitle, 'body': tBody, 'userId': tUserId},
            ),
            headers: {'Content-type': 'application/json; charset=UTF-8'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
