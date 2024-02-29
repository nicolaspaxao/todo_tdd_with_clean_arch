import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';
import 'package:todo_tdd_clen_arch/core/utils/constants.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();

  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  });
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio _dio;

  PostRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final response = await _dio.post(
      '$kBaseUrl/posts',
      data: jsonEncode({'title': title, 'body': body, 'userId': userId}),
      options: Options(
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(
          message: response.statusMessage!, statusCode: response.statusCode!);
    }

    // try {
    //   final response = await _dio.post(
    //     '$kBaseUrl/posts',
    //     data: jsonEncode({'title': title, 'body': body, 'userId': userId}),
    //     options: Options(
    //       headers: {'Content-type': 'application/json; charset=UTF-8'},
    //     ),
    //   );

    //   if (response.statusCode != 200 && response.statusCode != 201) {
    //     throw ApiException(
    //         message: response.statusMessage!, statusCode: response.statusCode!);
    //   }
    // } on ApiException {
    //   rethrow;
    // } catch (e) {
    //   throw ApiException(message: e.toString(), statusCode: 505);
    // }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('$kBaseUrl/posts');

      if (response.statusCode != 200) {
        throw ApiException(
            message: response.statusMessage!, statusCode: response.statusCode!);
      } else {
        return (response.data as List<dynamic>)
            .map((post) => PostModel.fromMap(post))
            .toList();
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
