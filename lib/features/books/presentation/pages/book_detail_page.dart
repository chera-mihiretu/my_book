import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_state.dart';

class BookDetailPage extends StatelessWidget {
  final String bookId;
  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Book Details'),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          // TODO: Implement UI
          return const Center(child: Text('Book Detail Page'));
        },
      ),
    );
  }
}
