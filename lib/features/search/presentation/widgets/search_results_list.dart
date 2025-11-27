import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../bloc/search_bloc.dart';
import 'author_search_card.dart';
import 'book_search_card.dart';
import '../../../author_detail/presentation/pages/author_detail_page.dart';

class SearchResultsList extends StatelessWidget {
  final ScrollController scrollController;

  const SearchResultsList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return _buildLoadingState();
        } else if (state is SearchLoaded) {
          if (state.books.isEmpty) {
            return _buildEmptyState(context, 'No books found');
          }
          return _buildBooksList(state, context);
        } else if (state is AuthorSearchLoaded) {
          if (state.authors.isEmpty) {
            return _buildEmptyState(context, 'No authors found');
          }
          return _buildAuthorsList(state, context);
        } else if (state is SearchError) {
          return _buildErrorState(context, state.message);
        }
        return _buildInitialState(context);
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoading.inline(size: 48),
          const SizedBox(height: 16),
          const Text(
            'Searching...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(SearchLoaded state, BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: state.hasReachedMax
          ? state.books.length
          : state.books.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.books.length) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: CustomLoading.inline(
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        return BookSearchCard(
          book: state.books[index],
          onTap: () {
            // TODO: Navigate to book details
          },
        );
      },
    );
  }

  Widget _buildAuthorsList(AuthorSearchLoaded state, BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: state.hasReachedMax
          ? state.authors.length
          : state.authors.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.authors.length) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: CustomLoading.inline(
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        return AuthorSearchCard(
          author: state.authors[index],
          onTap: () {
            final authorKey = state.authors[index].key.replaceAll(
              '/authors/',
              '',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthorDetailPage(
                  authorKey: authorKey,
                  authorName: state.authors[index].name,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.primary.withAlpha((0.5 * 255).toInt()),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.error.withAlpha((0.1 * 255).toInt()),
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                    colorScheme.secondary.withAlpha((0.1 * 255).toInt()),
                  ],
                ),
              ),
              child: Icon(
                Icons.auto_stories,
                size: 80,
                color: colorScheme.primary.withAlpha((0.5 * 255).toInt()),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Discover Your Next Read',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Search for books by title, author, or keyword',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
