import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About My Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline
            Text(
              'Build a Better Reading Habit with My Book',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Main Description
            Text(
              'Struggling to find time to read? My Book is your personal reading companion designed to help you organize your library, schedule your sessions, and actually finish the books you start.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Key Features Header
            Text(
              'Key Features',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Features List
            _buildFeatureItem(
              context,
              icon: Icons.search,
              title: 'Explore Our Library',
              description:
                  'Instantly search through our extensive database to find your next great read and add it directly to your Reading List.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.calendar_month,
              title: 'Smart Scheduling',
              description:
                  'Don\'t just list a book—plan it. Set a specific Start Date and customize your reading dates and times. We help you turn "someday" into "today."',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.notifications_active,
              title: 'Never Miss a Chapter',
              description:
                  'Stay on track with intelligent Push Notifications that alert you exactly when your scheduled reading time arrives.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.favorite,
              title: 'Curate Your Favorites',
              description:
                  'Keep your top picks accessible by adding them to your Favorites list.',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.emoji_events,
              title: 'Track Your Achievements',
              description:
                  'Experience the satisfaction of finishing a book. Once marked as "Completed," the book moves to your permanent archive. It locks to preserve your progress, serving as a trophy of your reading accomplishment.',
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Version 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(128),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
