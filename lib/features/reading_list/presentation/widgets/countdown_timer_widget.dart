import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int durationInMinutes;
  final int initialElapsedSeconds;
  final bool autoStart;
  final VoidCallback? onTimerComplete;
  final VoidCallback? onTimerStart;
  final Function(int elapsedSeconds)? onProgressSave;
  final Function(bool isRunning)? onTimerRunningChanged;

  const CountdownTimerWidget({
    super.key,
    required this.durationInMinutes,
    this.initialElapsedSeconds = 0,
    this.autoStart = false,
    this.onTimerComplete,
    this.onTimerStart,
    this.onProgressSave,
    this.onTimerRunningChanged,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int _remainingSeconds;
  late int _elapsedSeconds;
  Timer? _timer;
  Timer? _saveTimer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.initialElapsedSeconds;
    final totalSeconds = widget.durationInMinutes * 60;
    _remainingSeconds = totalSeconds - _elapsedSeconds;

    // Ensure remaining seconds is not negative
    if (_remainingSeconds < 0) {
      _remainingSeconds = 0;
    }

    // Auto-start timer if requested and there's time remaining
    if (widget.autoStart && _remainingSeconds > 0) {
      // Use post-frame callback to start after widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _saveTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    // Call onTimerStart callback when starting timer
    widget.onTimerStart?.call();

    setState(() {
      _isRunning = true;
    });

    // Notify parent that timer is now running
    widget.onTimerRunningChanged?.call(true);

    // Main countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _elapsedSeconds++;
        });
      } else {
        _stopTimer();
        widget.onTimerComplete?.call();
      }
    });

    // Auto-save timer (every 10 seconds)
    _saveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isRunning) {
        widget.onProgressSave?.call(_elapsedSeconds);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _saveTimer?.cancel();
    // Save progress when pausing
    widget.onProgressSave?.call(_elapsedSeconds);
    setState(() {
      _isRunning = false;
    });
    // Notify parent that timer is now stopped
    widget.onTimerRunningChanged?.call(false);
  }

  void _stopTimer() {
    _timer?.cancel();
    _saveTimer?.cancel();
    setState(() {
      _isRunning = false;
    });
    // Notify parent that timer is now stopped
    widget.onTimerRunningChanged?.call(false);
  }

  void _resetTimer() {
    _timer?.cancel();
    _saveTimer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _remainingSeconds = widget.durationInMinutes * 60;
      _isRunning = false;
    });
    // Save the reset progress
    widget.onProgressSave?.call(0);
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  double _getProgress() {
    final totalSeconds = widget.durationInMinutes * 60;
    if (totalSeconds == 0) return 0;
    return (_remainingSeconds / totalSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _getProgress();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha((0.2 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timer Display with Progress Ring
          Stack(
            alignment: Alignment.center,
            children: [
              // Progress Ring
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withAlpha((0.3 * 255).toInt()),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              // Time Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time Remaining',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Timer Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play/Pause Button
              IconButton.filled(
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 16),
              // Reset Button
              IconButton.outlined(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                iconSize: 28,
                style: IconButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
