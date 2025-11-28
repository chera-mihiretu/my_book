import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../bloc/reading_list_bloc.dart';
import '../bloc/reading_list_event.dart';
import '../bloc/reading_list_state.dart';
import '../widgets/reading_list_book_card.dart';

class ReadingListPage extends StatefulWidget {
  const ReadingListPage({super.key});

  @override
  State<ReadingListPage> createState() => _ReadingListPageState();
}

class _ReadingListPageState extends State<ReadingListPage> {
  final _scrollController = ScrollController();
  int _offset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadReadingList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadReadingList() {
    context.read<ReadingListBloc>().add(
      LoadReadingListEvent(limit: _limit, offset: _offset),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<ReadingListBloc>().state;
      if (state is ReadingListLoaded && state.hasMore) {
        _offset += _limit;
        _loadReadingList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading List')),
      body: RefreshIndicator(
        onRefresh: () async {
          _offset = 0;
          _loadReadingList();
        },
        child: BlocBuilder<ReadingListBloc, ReadingListState>(
          builder: (context, state) {
            if (state is ReadingListLoading && _offset == 0) {
              return Center(child: CustomLoading.inline());
            }

            if (state is ReadingListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _offset = 0;
                        _loadReadingList();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ReadingListLoaded) {
              if (state.books.isEmpty) {
                return const Center(child: Text('No books in reading list'));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.books.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.books.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomLoading.inline(),
                      ),
                    );
                  }

                  return ReadingListBookCard(book: state.books[index]);
                },
              );
            }

            return const Center(
              child: Text('Start adding books to your reading list!'),
            );
          },
        ),
      ),
    );
  }
}
