import 'package:flutter/material.dart';

class TimerInfoDialog extends StatefulWidget {
  final VoidCallback onDontShowAgain;
  final VoidCallback onGotIt;

  const TimerInfoDialog({
    super.key,
    required this.onDontShowAgain,
    required this.onGotIt,
  });

  @override
  State<TimerInfoDialog> createState() => _TimerInfoDialogState();

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onDontShowAgain,
    required VoidCallback onGotIt,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          TimerInfoDialog(onDontShowAgain: onDontShowAgain, onGotIt: onGotIt),
    );
  }
}

class _TimerInfoDialogState extends State<TimerInfoDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            'Reading Timer Info',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The countdown timer will help you track your reading time.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoPoint(
            context,
            Icons.timer,
            'The timer continues running even if you close the app',
          ),
          const SizedBox(height: 12),
          _buildInfoPoint(
            context,
            Icons.restore,
            'When you restart, the timer will resume from where you left off',
          ),
          const SizedBox(height: 12),
          _buildInfoPoint(
            context,
            Icons.save,
            'Your progress is automatically saved every 10 seconds',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(
                (0.3 * 255).toInt(),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can pause, resume, or reset the timer at any time',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Don't show again checkbox
          InkWell(
            onTap: () {
              setState(() {
                _dontShowAgain = !_dontShowAgain;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _dontShowAgain,
                      onChanged: (value) {
                        setState(() {
                          _dontShowAgain = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Don't show me this anymore",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_dontShowAgain) {
                widget.onDontShowAgain();
              }
              widget.onGotIt();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Got it!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPoint(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
