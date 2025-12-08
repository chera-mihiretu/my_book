import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../books/presentation/bloc/book_detail_bloc.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_bloc.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_event.dart';
import '../../../reading_progress/presentation/bloc/reading_progress_state.dart';
import '../../../reading_progress/presentation/widgets/timer_info_dialog.dart';
import '../widgets/countdown_timer_widget.dart';
import '../bloc/reading_list_bloc.dart';
import '../bloc/reading_list_event.dart';
import '../bloc/reading_list_state.dart';

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
      // Use Bloc to fetch details
      final bookOLIDKey = widget.book.bookKey!.substring(7);
      context.read<BookDetailBloc>().add(FetchBookDetail(bookOLIDKey));
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
      _showUpdatePageDialog();
    }
  }

  void _showUpdatePageDialog() {
    final book = _detailedBook ?? widget.book;
    final currentPage = book.currentPage ?? 0;
    final totalPages = book.numberOfPages ?? 0;
    final controller = TextEditingController(); // Start empty
    String? errorText;
    bool isCompleted = false;
    bool showCheckbox = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Session Complete!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('What page have you reached?'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Page Number',
                      hintText: 'Current: $currentPage',
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final page = int.tryParse(value);
                      if (errorText != null) {
                        setDialogState(() => errorText = null);
                      }
                      // Show checkbox if last page reached
                      if (page != null && page == totalPages) {
                        if (!showCheckbox) {
                          setDialogState(() {
                            showCheckbox = true;
                            isCompleted = true; // Auto-check for convenience
                          });
                        }
                      } else {
                        if (showCheckbox) {
                          setDialogState(() {
                            showCheckbox = false;
                            isCompleted = false;
                          });
                        }
                      }
                    },
                  ),
                  if (totalPages > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Total pages: $totalPages',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  if (showCheckbox)
                    CheckboxListTile(
                      title: const Text('Completed'),
                      value: isCompleted,
                      onChanged: (val) {
                        setDialogState(() => isCompleted = val ?? false);
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Check if valid
                    final input = int.tryParse(controller.text);
                    if (input == null) {
                      setDialogState(
                        () => errorText = 'Please enter a valid number',
                      );
                      return;
                    }

                    if (input <= currentPage) {
                      setDialogState(
                        () => errorText =
                            'Must be greater than current page ($currentPage)',
                      );
                      return;
                    }

                    if (totalPages > 0 && input > totalPages) {
                      setDialogState(
                        () => errorText =
                            'Must be less than or equal to total pages ($totalPages)',
                      );
                      return;
                    }

                    Navigator.of(context).pop();
                    _submitPageUpdate(input, isCompleted: isCompleted);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitPageUpdate(int newPage, {bool isCompleted = false}) {
    final bookKey = widget.book.bookKey ?? widget.book.id;
    if (bookKey != null) {
      context.read<ReadingListBloc>().add(
        UpdateCurrentPageEvent(bookKey, newPage, isCompleted: isCompleted),
      );
    }
  }

  void _showCelebration() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const FunCelebrationDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = _detailedBook ?? widget.book;

    return MultiBlocListener(
      listeners: [
        BlocListener<ReadingProgressBloc, ReadingProgressState>(
          listener: (context, state) {
            if (state is ReadingProgressLoaded) {
              setState(() {
                _initialElapsedSeconds = state.progress?.elapsedSeconds ?? 0;
                _showDialog = state.showDialog;
              });
            }
          },
        ),
        BlocListener<BookDetailBloc, BookDetailState>(
          listener: (context, state) {
            if (state is BookDetailLoading) {
              setState(() {
                _isLoadingDetails = true;
              });
            } else if (state is BookDetailLoaded) {
              final detailedBook = state.bookDetail;
              setState(() {
                _detailedBook = widget.book.copyWith(
                  subjects: detailedBook.subjects ?? widget.book.subjects,
                  publishers: detailedBook.publishers ?? widget.book.publishers,
                  numberOfPages:
                      detailedBook.numberOfPages ?? widget.book.numberOfPages,
                  publishDate:
                      detailedBook.publishDate ?? widget.book.publishDate,
                  coverUrls: detailedBook.coverUrls ?? widget.book.coverUrls,
                );
                _isLoadingDetails = false;
              });
            } else if (state is BookDetailError) {
              setState(() {
                _detailedBook = widget.book;
                _isLoadingDetails = false;
              });
              CustomSnackBar.show(
                context,
                message: 'Could not load additional book details',
                type: SnackBarType.warning,
              );
            }
          },
        ),
        BlocListener<ReadingListBloc, ReadingListState>(
          listener: (context, state) {
            if (state is ReadingListUpdateSuccess) {
              setState(() {
                _detailedBook = state.book;
              });
              _showCelebration();
            } else if (state is ReadingListError) {
              CustomSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
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

                      if (book.durationToRead != null &&
                          !book.completed &&
                          (book.currentPage != book.numberOfPages)) ...[
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
    final progress = (book.currentPage ?? 0) / (book.numberOfPages ?? 1);
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

class FunCelebrationDialog extends StatefulWidget {
  const FunCelebrationDialog({super.key});

  @override
  State<FunCelebrationDialog> createState() => _FunCelebrationDialogState();
}

class _FunCelebrationDialogState extends State<FunCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _rotateAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.celebration,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Awesome Job!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You updated your progress.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
