import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  bool _notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoaded) {
          setState(() {
            _notificationEnabled = state.settings.notification;
          });
        } else if (state is NotificationUpdated) {
          setState(() {
            _notificationEnabled = state.settings.notification;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.primary,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is NotificationLoading)
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enable Notifications',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _notificationEnabled
                                  ? 'You will receive notifications'
                                  : 'Notifications are disabled',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface.withAlpha(
                                  (0.6 * 255).toInt(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: _notificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationEnabled = value;
                            });
                          },
                          activeColor: colorScheme.primary,
                          activeTrackColor: colorScheme.primary.withAlpha(
                            (0.5 * 255).toInt(),
                          ),
                          inactiveThumbColor: colorScheme.onSurface.withAlpha(
                            (0.4 * 255).toInt(),
                          ),
                          inactiveTrackColor:
                              colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
                ),
              ),
            ),
            FilledButton(
              onPressed: state is NotificationLoading
                  ? null
                  : () {
                      context.read<NotificationBloc>().add(
                        UpdateNotificationSettingsEvent(_notificationEnabled),
                      );
                    },
              child: const Text('Apply', style: TextStyle(fontSize: 14)),
            ),
          ],
        );
      },
    );
  }
}
