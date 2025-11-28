import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/utils/constants.dart';

class ReadingListBookCard extends StatelessWidget {
  final BookModel book;

  const ReadingListBookCard({super.key, required this.book});

  int _getDaysSinceStarted() {
    if (book.startedTime == null) return 0;
    return DateTime.now().difference(book.startedTime!).inDays;
  }

  String _getImageUrl() {
    if (book.custom) {
      return book.coverPhotoUrl ?? '';
    } else {
      if (book.bookKey == null) return '';

      return ApiEndpoints.bookPhotoUrl(
        book.bookKey!.substring(7, book.bookKey!.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysSinceStarted = _getDaysSinceStarted();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _getImageUrl(),
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Book Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    book.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Author
                  if (book.authorName != null && book.authorName!.isNotEmpty)
                    Text(
                      book.authorName!.first,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),

                  // Time Progress Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withAlpha(
                            (0.1 * 255).toInt(),
                          ),
                          theme.colorScheme.secondary.withAlpha(
                            (0.1 * 255).toInt(),
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$daysSinceStarted ${daysSinceStarted == 1 ? 'day' : 'days'} reading',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Page Progress
                  if (book.currentPage != null && book.numberOfPages != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Page ${book.currentPage}/${book.numberOfPages}',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '${((book.currentPage! / book.numberOfPages!) * 100).toStringAsFixed(0)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: book.currentPage! / book.numberOfPages!,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
