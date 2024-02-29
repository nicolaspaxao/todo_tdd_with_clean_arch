import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';
import 'package:todo_tdd_clen_arch/core/utils/constants.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/datasources/post_remote_datasource.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  late Dio mockDio;
  late PostRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDioClient();
    dataSource = PostRemoteDataSourceImpl(dio: mockDio);
  });

  const tBody = 'tBody';
  const tTitle = 'tTitle';
  const tUserId = 1;

  final tResponse = [const PostModel.empty().toMap()];

  group('getPosts', () {
    test(
      'should return a list of PostModel when the call to Dio is successful',
      () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: tResponse,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        final result = await dataSource.getPosts();

        expect(result, isA<List<PostModel>>());
        expect(result.length, equals(1));

        verify(() => mockDio.get('$kBaseUrl/posts')).called(1);
        verifyNoMoreInteractions(mockDio);
      },
    );

    test(
      'should throw an ApiException when the call to Dio is unsuccessful',
      () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        );

        final call = dataSource.getPosts;

        expect(() => call(), throwsA(isA<ApiException>()));
        verify(() => mockDio.get('$kBaseUrl/posts')).called(1);
        verifyNoMoreInteractions(mockDio);
      },
    );
  });

  group('createPost', () {
    test(
      'should perform a POST request with the given parameters',
      () async {
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: Options(
                headers: {'Content-type': 'application/json; charset=UTF-8'},
              ),
            )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: RequestOptions(),
            ));

        await dataSource.createPost(
          title: tTitle,
          body: tBody,
          userId: tUserId,
        );

        verify(
          () => mockDio.post(
            '$kBaseUrl/posts',
            data: jsonEncode(
              {'title': tTitle, 'body': tBody, 'userId': tUserId},
            ),
            options: Options(
              headers: {'Content-type': 'application/json; charset=UTF-8'},
            ),
          ),
        ).called(1);

        verifyNoMoreInteractions(mockDio);
      },
    );

    test(
      'should throw an ApiException when the call to Dio is unsuccessful',
      () async {
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: Options(
                  headers: {'Content-type': 'application/json; charset=UTF-8'}),
            )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 404,
              statusMessage: 'Error',
              requestOptions: RequestOptions(),
            ));

        await dataSource.createPost(
            title: tTitle, body: tBody, userId: tUserId);

        verify(
          () => mockDio.post(
            '$kBaseUrl/posts',
            data: {'title': tTitle, 'body': tBody, 'userId': tUserId},
            options: Options(
              headers: {'Content-type': 'application/json; charset=UTF-8'},
            ),
          ),
        ).called(1);
      },
    );
  });
}
