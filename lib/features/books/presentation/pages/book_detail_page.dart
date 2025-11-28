import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../bloc/book_detail_bloc.dart';
import '../../../../core/models/book_model.dart';
import '../../../favorites/presentation/bloc/favorite_bloc.dart';
import '../../../favorites/presentation/bloc/favorite_event.dart';
import '../../../favorites/presentation/bloc/favorite_state.dart';

class BookDetailPage extends StatefulWidget {
  final String bookOLIDKey;
  final String title;

  const BookDetailPage({
    super.key,
    required this.bookOLIDKey,
    required this.title,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to fetch book details using existing bloc
    context.read<BookDetailBloc>().add(FetchBookDetail(widget.bookOLIDKey));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteError) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is FavoriteInitial &&
            state != const FavoriteInitial()) {
          CustomSnackBar.show(
            context,
            message: 'Added to favorites!',
            type: SnackBarType.success,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading) {
              return Center(child: CustomLoading.inline(size: 48));
            } else if (state is BookDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is BookDetailLoaded) {
              return _buildBody(context, state.bookDetail);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BookModel book) {
    final coverUrl =
        book.coverUrls?['large'] ??
        book.coverUrls?['medium'] ??
        book.coverUrls?['small'];
    final authors = book.authorName?.join(', ');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          if (coverUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  coverUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.book, size: 100),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Title
          Text(
            book.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          // Authors
          if (authors != null) ...[
            const SizedBox(height: 8),
            Text(
              'by $authors',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    CustomSnackBar.show(
                      context,
                      message: 'Coming Soon',
                      type: SnackBarType.warning,
                    );
                  },
                  icon: const Icon(Icons.bookmark_add),
                  label: const Text('Add to Reading List'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<FavoriteBloc>().add(AddFavoriteEvent(book));
                  },
                  icon: Icon(
                    book.favorite ? Icons.favorite : Icons.favorite_border,
                    color: book.favorite ? Colors.red : null,
                  ),
                  iconSize: 28,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Book Info
          _buildInfoRow(context, 'Pages', book.numberOfPages?.toString()),
          _buildInfoRow(context, 'Publisher', book.publishers?.join(', ')),
          _buildInfoRow(context, 'Published', book.publishDate),

          // Subjects
          if (book.subjects != null && book.subjects!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Subjects',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.subjects!
                  .map(
                    (subject) => Chip(
                      label: Text(subject),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
