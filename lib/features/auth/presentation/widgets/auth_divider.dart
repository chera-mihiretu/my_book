import 'package:flutter/material.dart';

/// Divider with text for auth pages
class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, this.text = 'OR'});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha((0.2 * 255).toInt());
    final textColor = Theme.of(
      context,
    ).colorScheme.onSurface.withAlpha((0.6 * 255).toInt());

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
    );
  }
}
