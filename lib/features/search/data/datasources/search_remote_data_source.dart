import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/utils/constants.dart';
import '../models/author_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<BookModel>> searchBooks(String query, {int page = 1});
  Future<List<AuthorModel>> searchAuthors(String query, {int page = 1});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BookModel>> searchBooks(String query, {int page = 1}) async {
    log(ApiEndpoints.searchBook(query, page: page));
    final response = await client.get(
      Uri.parse(ApiEndpoints.searchBook(query, page: page)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> docs = jsonMap['docs'];

      return docs.map((doc) => BookModel.fromJson(doc)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<AuthorModel>> searchAuthors(String query, {int page = 1}) async {
    log(ApiEndpoints.searchAuthor(query, page: page));
    final response = await client.get(
      Uri.parse(ApiEndpoints.searchAuthor(query, page: page)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> docs = jsonMap['docs'];

      return docs.map((doc) => AuthorModel.fromJson(doc)).toList();
    } else {
      throw ServerException();
    }
  }
}
