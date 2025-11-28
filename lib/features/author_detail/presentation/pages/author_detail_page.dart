import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/author_detail_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../bloc/author_detail_bloc.dart';

class AuthorDetailPage extends StatefulWidget {
  final String authorKey;
  final String authorName;

  const AuthorDetailPage({
    super.key,
    required this.authorKey,
    required this.authorName,
  });

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch event to load author details using existing bloc
    context.read<AuthorDetailBloc>().add(LoadAuthorDetail(widget.authorKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthorDetailBloc, AuthorDetailState>(
        builder: (context, state) {
          if (state is AuthorDetailLoading) {
            return _buildLoadingState();
          } else if (state is AuthorDetailLoaded) {
            return _buildLoadedState(context, state.authorDetail);
          } else if (state is AuthorDetailError) {
            return _buildErrorState(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
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
            'Loading author details...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, AuthorDetailModel author) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, author),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(context, author),
              const SizedBox(height: 24),
              if (author.bio != null) _buildBioSection(context, author.bio!),
              if (author.photos != null && author.photos!.isNotEmpty)
                _buildPhotosSection(context, author.photos!),
              if (author.links != null && author.links!.isNotEmpty)
                _buildLinksSection(context, author.links!),
              if (author.alternateNames != null &&
                  author.alternateNames!.isNotEmpty)
                _buildAlternateNamesSection(context, author.alternateNames!),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, AuthorDetailModel author) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AuthorDetailModel author) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          Hero(
            tag: 'author_${author.key ?? widget.authorKey}',
            child: Container(
              width: 120,
              height: 120,
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
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  author.name[0].toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            author.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (author.personalName != null && author.personalName != author.name)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                author.personalName!,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (author.birthDate != null || author.deathDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${author.birthDate ?? "?"} - ${author.deathDate ?? "Present"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(
                        (0.6 * 255).toInt(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBioSection(BuildContext context, String bio) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Biography',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: colorScheme.onSurface.withAlpha((0.8 * 255).toInt()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosSection(BuildContext context, List<int> photos) {
    final colorScheme = Theme.of(context).colorScheme;
    final validPhotos = photos.where((id) => id > 0).toList();

    if (validPhotos.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.photo_library, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: validPhotos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      ApiEndpoints.authorPhotoUrl(
                        validPhotos[index].toString(),
                      ),
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 150,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(
    BuildContext context,
    List<Map<String, dynamic>> links,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.link, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'External Links',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...links.map((link) => _buildLinkItem(context, link)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, Map<String, dynamic> link) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = link['title'] as String?;
    final url = link['url'] as String?;

    if (title == null || url == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(Icons.open_in_new, size: 20, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlternateNamesSection(BuildContext context, List<String> names) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_outline, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Also Known As',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: names
                    .map(
                      (name) => Chip(
                        label: Text(name),
                        backgroundColor: colorScheme.primary.withAlpha(
                          (0.1 * 255).toInt(),
                        ),
                        labelStyle: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
