import 'package:flutter/material.dart';

/// Logo section widget for auth pages
class AuthLogo extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final IconData icon;

  const AuthLogo({
    super.key,
    this.size = 80,
    this.backgroundColor = const Color(0xFF6B4EFF),
    this.icon = Icons.menu_book_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: size * 0.5, color: Colors.white),
      ),
    );
  }
}
