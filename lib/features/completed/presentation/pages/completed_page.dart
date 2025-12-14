import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/book_card.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../reading_list/presentation/pages/reading_list_book_detail_page.dart';
import '../bloc/completed_bloc.dart';
import '../bloc/completed_event.dart';
import '../bloc/completed_state.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  void initState() {
    super.initState();
    // Load completed books when page initializes
    context.read<CompletedBloc>().add(const LoadCompletedBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Completed Books',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CompletedBloc>().add(
                const LoadCompletedBooksEvent(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CompletedBloc, CompletedState>(
        builder: (context, state) {
          if (state is CompletedLoading) {
            return _buildLoadingState();
          } else if (state is CompletedBooksLoaded) {
            if (state.books.isEmpty) {
              return _buildEmptyState(colorScheme);
            }
            return _buildCompletedBooksList(state, context);
          } else if (state is CompletedError) {
            return _buildErrorState(colorScheme, state.message);
          }
          return _buildEmptyState(colorScheme);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(child: CustomLoading.inline());
  }

  Widget _buildCompletedBooksList(
    CompletedBooksLoaded state,
    BuildContext context,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: state.books.length,
      itemBuilder: (context, index) {
        final book = state.books[index];
        return BookCard(
          fromDatabase: true,
          book: book,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadingListBookDetailPage(book: book),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
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
                Icons.check_circle_outline,
                size: 80,
                color: colorScheme.primary.withAlpha((0.5 * 255).toInt()),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Completed Books Yet',
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
                'Books you finish will appear here',
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

  Widget _buildErrorState(ColorScheme colorScheme, String message) {
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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CompletedBloc>().add(
                const LoadCompletedBooksEvent(),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
