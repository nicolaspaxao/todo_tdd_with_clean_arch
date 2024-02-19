import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_tdd_clen_arch/core/utils/typedef.dart';
import 'package:todo_tdd_clen_arch/src/posts/data/models/post.dart';
import 'package:todo_tdd_clen_arch/src/posts/domain/entities/post.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = PostModel.empty();

  test('should be an instance of [Post]', () {
    expect(tModel, isA<Post>());
  });

  final tJson = fixture('post.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return [PostModel] with right data', () {
      final result = PostModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });
  group('fromJson', () {
    test('should return [PostModel] with right data', () {
      final result = PostModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });
  group('toMap', () {
    test('should return a [Map] with right data', () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [JSON] with right data', () {
      final result = tModel.toJson();
      final json = jsonEncode(
        {
          "userId": 1,
          "id": 1,
          "title": "_empty",
          "body": "_empty",
        },
      );

      expect(result, equals(json));
    });
  });
  group('copyWith', () {
    test('should change a data from the model', () {
      final result = tModel.copyWith(title: 'New title');
      expect(result.title, equals('New title'));
    });
  });
}
