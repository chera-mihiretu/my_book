import 'package:flutter/material.dart';

class CustomLoading {
  static OverlayEntry? _overlayEntry;

  /// Show a full-screen loading overlay
  static void show(BuildContext context, {String? message}) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide the loading overlay
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Show inline loading indicator (for use inside widgets)
  static Widget inline({String? message, Color? color, double size = 24}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: color != null
                  ? AlwaysStoppedAnimation<Color>(color)
                  : null,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}
