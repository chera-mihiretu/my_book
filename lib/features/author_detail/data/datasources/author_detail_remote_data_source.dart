import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../../../core/models/work_model.dart';
import '../../../../core/utils/constants.dart';

abstract class AuthorDetailRemoteDataSource {
  Future<AuthorDetailModel> getAuthorDetail(String authorKey);
  Future<List<WorkModel>> getAuthorWorks(String authorKey);
}

class AuthorDetailRemoteDataSourceImpl implements AuthorDetailRemoteDataSource {
  final http.Client client;

  AuthorDetailRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthorDetailModel> getAuthorDetail(String authorKey) async {
    final response = await client.get(
      Uri.parse(ApiEndpoints.getAuthorDetail(authorKey)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return AuthorDetailModel.fromJson(jsonMap);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WorkModel>> getAuthorWorks(String authorKey) async {
    log(ApiEndpoints.authorWorks(authorKey));

    final response = await client.get(
      Uri.parse(ApiEndpoints.authorWorks(authorKey)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> entries = jsonMap['entries'] ?? [];
      return entries.map((e) => WorkModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }
}
