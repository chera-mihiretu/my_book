import 'package:flutter/material.dart';
import 'package:new_project/di/injector.dart';
import 'package:new_project/features/auth/presentation/pages/login_page.dart';
import 'package:new_project/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<Supabase>().client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 40),
                  const CircularProgressIndicator(
                    strokeWidth: 1,

                    color: Color(0xFF6B4EFF),
                  ),
                ],
              ),
            ),
          );
        }

        final authState = snapshot.data;
        final session = authState?.session;

        if (session != null) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
