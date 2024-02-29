import 'dart:convert';

import 'package:http/http.dart' as http;
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
  final http.Client _client;

  PostRemoteDataSourceImpl({required http.Client client}) : _client = client;

  @override
  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$kBaseUrl/posts'),
        body: jsonEncode({'title': title, 'body': body, 'userId': userId}),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            message: response.body, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _client.get(Uri.parse('$kBaseUrl/posts'));

      if (response.statusCode != 200) {
        throw ApiException(
            message: response.body, statusCode: response.statusCode);
      } else {
        return (jsonDecode(response.body) as List<dynamic>)
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
