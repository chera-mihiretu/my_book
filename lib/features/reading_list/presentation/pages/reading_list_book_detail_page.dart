import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../books/data/datasources/book_detail_remote_data_source.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_bloc.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_event.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_state.dart';
import '../../../reading_progress/presentation/widgets/timer_info_dialog.dart';
import '../../../../di/injector.dart';
import '../widgets/countdown_timer_widget.dart';

class ReadingListBookDetailPage extends StatefulWidget {
  final BookModel book;

  const ReadingListBookDetailPage({super.key, required this.book});

  @override
  State<ReadingListBookDetailPage> createState() =>
      _ReadingListBookDetailPageState();
}

class _ReadingListBookDetailPageState extends State<ReadingListBookDetailPage> {
  BookModel? _detailedBook;
  bool _isLoadingDetails = false;
  int _initialElapsedSeconds = 0;
  bool _showDialog = true;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _loadBookDetails();

    // Dispatch event to load reading progress via BLoC
    final bookKey = widget.book.bookKey ?? widget.book.id;
    if (bookKey != null) {
      context.read<ReadingProgressBloc>().add(
        LoadReadingProgressEvent(bookKey),
      );
    }
  }

  Future<void> _loadBookDetails() async {
    // If it's a custom book, we already have all the details
    if (widget.book.custom) {
      setState(() {
        _detailedBook = widget.book;
      });
      return;
    }

    // For non-custom books, fetch additional details from Open Library
    if (widget.book.bookKey != null) {
      setState(() {
        _isLoadingDetails = true;
      });

      try {
        final bookOLIDKey = widget.book.bookKey!.substring(7);
        final dataSource = sl<BookDetailRemoteDataSource>();
        final detailedBook = await dataSource.getBookDetail(bookOLIDKey);

        // Merge the detailed book data with the existing book data
        setState(() {
          _detailedBook = widget.book.copyWith(
            subjects: detailedBook.subjects ?? widget.book.subjects,
            publishers: detailedBook.publishers ?? widget.book.publishers,
            numberOfPages:
                detailedBook.numberOfPages ?? widget.book.numberOfPages,
            publishDate: detailedBook.publishDate ?? widget.book.publishDate,
            coverUrls: detailedBook.coverUrls ?? widget.book.coverUrls,
          );
          _isLoadingDetails = false;
        });
      } catch (e) {
        setState(() {
          _detailedBook = widget.book;
          _isLoadingDetails = false;
        });
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Could not load additional book details',
            type: SnackBarType.warning,
          );
        }
      }
    } else {
      setState(() {
        _detailedBook = widget.book;
      });
    }
  }

  void _onTimerStart() {
    // Check dialog preference from BLoC state and show if needed
    if (_showDialog && mounted) {
      _showTimerInfoDialog();
    }
  }

  void _showTimerInfoDialog() {
    TimerInfoDialog.show(
      context,
      onDontShowAgain: () {
        // Dispatch event to update preference via BLoC
        context.read<ReadingProgressBloc>().add(
          const UpdateDialogPreferenceEvent(false),
        );
      },
      onGotIt: () {
        // Dialog dismissed
      },
    );
  }

  void _saveReadingProgress(int elapsedSeconds) {
    final bookKey = widget.book.bookKey ?? widget.book.id;
    if (bookKey == null) return;

    final totalDurationSeconds = (widget.book.durationToRead ?? 0) * 60;

    // Dispatch event to save progress via BLoC
    context.read<ReadingProgressBloc>().add(
      SaveReadingProgressEvent(
        bookKey: bookKey,
        elapsedSeconds: elapsedSeconds,
        totalDurationSeconds: totalDurationSeconds,
      ),
    );
  }

  String _getImageUrl() {
    if (widget.book.custom) {
      return widget.book.coverPhotoUrl ?? '';
    } else {
      // Try to get from coverUrls first (from detailed API)
      if (_detailedBook?.coverUrls != null) {
        return _detailedBook!.coverUrls!['large'] ??
            _detailedBook!.coverUrls!['medium'] ??
            _detailedBook!.coverUrls!['small'] ??
            '';
      }
      // Fallback to constructing URL from bookKey
      if (widget.book.bookKey != null) {
        return ApiEndpoints.bookPhotoUrl(widget.book.bookKey!.substring(7));
      }
      return '';
    }
  }

  void _onStartReading() {
    // TODO: Implement navigation to reading view or update reading status
    CustomSnackBar.show(
      context,
      message: 'Starting reading session...',
      type: SnackBarType.success,
    );
  }

  void _onTimerComplete() {
    if (mounted) {
      CustomSnackBar.show(
        context,
        message: 'Reading time completed!',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = _detailedBook ?? widget.book;

    return BlocListener<ReadingProgressBloc, ReadingProgressState>(
      listener: (context, state) {
        if (state is ReadingProgressLoaded) {
          setState(() {
            _initialElapsedSeconds = state.progress?.elapsedSeconds ?? 0;
            _showDialog = state.showDialog;
          });
        }
      },
      child: PopScope(
        canPop: !_isTimerRunning,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // Show confirmation dialog if timer is running
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Timer is Running'),
              content: const Text(
                'The countdown timer is currently running. If you leave this page, the timer will stop. Are you sure you want to leave?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave'),
                ),
              ],
            ),
          );

          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Book Cover
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'book_cover_${widget.book.id ?? widget.book.bookKey}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _getImageUrl(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.book, size: 100),
                            );
                          },
                        ),
                        // Gradient overlay for better text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha((0.7 * 255).toInt()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Author
                      if (book.authorName != null &&
                          book.authorName!.isNotEmpty)
                        Text(
                          'by ${book.authorName!.join(', ')}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Loading indicator for additional details
                      if (_isLoadingDetails)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomLoading.inline(),
                          ),
                        ),

                      // Book Information
                      if (!_isLoadingDetails) ...[
                        _buildInfoCard(context, book),
                        const SizedBox(height: 24),
                      ],

                      // Countdown Timer
                      if (book.durationToRead != null) ...[
                        Text(
                          'Reading Timer',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CountdownTimerWidget(
                          durationInMinutes: book.durationToRead!,
                          initialElapsedSeconds: _initialElapsedSeconds,
                          autoStart: _initialElapsedSeconds > 0,
                          onStartReading: _onStartReading,
                          onTimerStart: _onTimerStart,
                          onTimerComplete: _onTimerComplete,
                          onProgressSave: _saveReadingProgress,
                          onTimerRunningChanged: (isRunning) {
                            setState(() {
                              _isTimerRunning = isRunning;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Subjects
                      if (book.subjects != null &&
                          book.subjects!.isNotEmpty) ...[
                        Text(
                          'Subjects',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.subjects!
                              .take(10) // Limit to 10 subjects
                              .map(
                                (subject) => Chip(
                                  label: Text(subject),
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Reading Progress
                      if (book.currentPage != null &&
                          book.numberOfPages != null)
                        _buildProgressCard(context, book),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, BookModel book) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (book.numberOfPages != null)
              _buildInfoRow(
                context,
                Icons.menu_book,
                'Pages',
                book.numberOfPages.toString(),
              ),
            if (book.publishers != null && book.publishers!.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.business,
                'Publisher',
                book.publishers!.first,
              ),
            if (book.publishDate != null)
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Published',
                book.publishDate!,
              ),
            if (book.firstPublishYear != null)
              _buildInfoRow(
                context,
                Icons.history,
                'First Published',
                book.firstPublishYear.toString(),
              ),
            if (book.language != null && book.language!.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.language,
                'Language',
                book.language!.join(', ').toUpperCase(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, BookModel book) {
    final theme = Theme.of(context);
    final progress = book.currentPage! / book.numberOfPages!;
    final percentage = (progress * 100).toStringAsFixed(0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reading Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Page ${book.currentPage} of ${book.numberOfPages}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
