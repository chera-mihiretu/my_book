import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../../../core/utils/constants.dart';

abstract class AuthorDetailRemoteDataSource {
  Future<AuthorDetailModel> getAuthorDetail(String authorKey);
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
}
