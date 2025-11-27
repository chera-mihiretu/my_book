import 'package:flutter/material.dart';
import 'package:new_project/core/utils/constants.dart';
import '../../../../core/models/book_model.dart';

class BookSearchCard extends StatefulWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const BookSearchCard({super.key, required this.book, this.onTap});

  @override
  State<BookSearchCard> createState() => _BookSearchCardState();
}

class _BookSearchCardState extends State<BookSearchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).toInt()),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Book Cover with Gradient Overlay
                  _buildBookCover(colorScheme),
                  // Book Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.book.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Author with Avatar
                          _buildAuthorInfo(colorScheme),
                          const SizedBox(height: 12),
                          // Metadata Row
                          _buildMetadataRow(colorScheme),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover(ColorScheme colorScheme) {
    return Hero(
      tag: 'book_${widget.book.bookKey ?? widget.book.title}',
      child: Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withAlpha((0.1 * 255).toInt()),
              colorScheme.secondary.withAlpha((0.1 * 255).toInt()),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.book.coverI != null)
              Image.network(
                ApiEndpoints.bookPhotoUrl(
                  widget.book.coverEditionKey.toString(),
                ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderCover(colorScheme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildShimmerEffect(colorScheme);
                },
              )
            else
              _buildPlaceholderCover(colorScheme),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((0.3 * 255).toInt()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withAlpha((0.3 * 255).toInt()),
            colorScheme.secondary.withAlpha((0.3 * 255).toInt()),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories,
          size: 48,
          color: colorScheme.onSurface.withAlpha((0.3 * 255).toInt()),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerHighest,
            colorScheme.surface,
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorInfo(ColorScheme colorScheme) {
    final authors = widget.book.authorName?.join(', ') ?? 'Unknown Author';

    return Row(
      children: [
        // Author Avatar
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withAlpha((0.2 * 255).toInt()),
                colorScheme.secondary.withAlpha((0.2 * 255).toInt()),
              ],
            ),
          ),
          child: Center(
            child: Text(
              authors[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            authors,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.book.firstPublishYear != null)
          _buildBadge(
            icon: Icons.calendar_today,
            label: widget.book.firstPublishYear.toString(),
            colorScheme: colorScheme,
          ),
        if (widget.book.editionCount != null)
          _buildBadge(
            icon: Icons.library_books,
            label: '${widget.book.editionCount} editions',
            colorScheme: colorScheme,
          ),
        if (widget.book.language != null && widget.book.language!.isNotEmpty)
          _buildBadge(
            icon: Icons.language,
            label: widget.book.language!.first.toUpperCase(),
            colorScheme: colorScheme,
          ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
