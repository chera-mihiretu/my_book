import 'package:flutter/material.dart';

/// Welcome text widget for auth pages
class AuthWelcomeText extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthWelcomeText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt()),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
