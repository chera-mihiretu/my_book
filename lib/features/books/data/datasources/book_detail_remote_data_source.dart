import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project/core/models/book_model.dart';
import 'package:new_project/core/utils/constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class BookDetailRemoteDataSource {
  Future<BookModel> getBookDetail(String bookOLIDKey);
}

class BookDetailRemoteDataSourceImpl implements BookDetailRemoteDataSource {
  final http.Client client;

  BookDetailRemoteDataSourceImpl({required this.client});

  @override
  Future<BookModel> getBookDetail(String bookOLIDKey) async {
    final response = await client.get(
      Uri.parse(ApiEndpoints.getBookDetail(bookOLIDKey)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      if (jsonMap.containsKey('OLID:$bookOLIDKey')) {
        return BookModel.fromJson(jsonMap['OLID:$bookOLIDKey']);
      }
      throw ServerException();
    } else {
      throw ServerException();
    }
  }
}
