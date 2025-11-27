import 'package:flutter/material.dart';
import '../../data/models/author_model.dart';

class AuthorSearchCard extends StatefulWidget {
  final AuthorModel author;
  final VoidCallback? onTap;

  const AuthorSearchCard({super.key, required this.author, this.onTap});

  @override
  State<AuthorSearchCard> createState() => _AuthorSearchCardState();
}

class _AuthorSearchCardState extends State<AuthorSearchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
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
        child: Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(
                0,
              ), // IntrinsicHeight handles padding inside
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Author Avatar
                    _buildAuthorAvatar(colorScheme),
                    // Author Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              widget.author.name,
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
                            // Birth/Death Dates
                            if (widget.author.birthDate != null ||
                                widget.author.deathDate != null)
                              _buildDates(colorScheme),
                            if (widget.author.birthDate != null ||
                                widget.author.deathDate != null)
                              const SizedBox(height: 8),
                            // Top Work
                            if (widget.author.topWork != null)
                              _buildTopWork(colorScheme),
                            if (widget.author.topWork != null)
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
      ),
    );
  }

  Widget _buildAuthorAvatar(ColorScheme colorScheme) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withAlpha((0.15 * 255).toInt()),
            colorScheme.secondary.withAlpha((0.15 * 255).toInt()),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.author.name[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDates(ColorScheme colorScheme) {
    final birthDate = widget.author.birthDate ?? '?';
    final deathDate = widget.author.deathDate ?? 'Present';

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$birthDate - $deathDate',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTopWork(ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          Icons.auto_stories,
          size: 14,
          color: colorScheme.primary.withAlpha((0.7 * 255).toInt()),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            widget.author.topWork!,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.primary.withAlpha((0.8 * 255).toInt()),
              fontStyle: FontStyle.italic,
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
        if (widget.author.workCount != null)
          _buildBadge(
            icon: Icons.library_books,
            label: '${widget.author.workCount} works',
            colorScheme: colorScheme,
          ),
        if (widget.author.topSubjects != null &&
            widget.author.topSubjects!.isNotEmpty)
          _buildBadge(
            icon: Icons.category,
            label: widget.author.topSubjects!.first,
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
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
