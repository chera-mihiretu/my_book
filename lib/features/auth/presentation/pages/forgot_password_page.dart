import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Email'),
          content: Text('Is this email correct?\n${_emailController.text}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(
                  ForgotPasswordRequested(email: _emailController.text),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            CustomLoading.show(context);
          } else {
            CustomLoading.hide();
          }

          if (state is PasswordResetEmailSent) {
            CustomSnackBar.show(
              context,
              message: 'Reset code sent to your email',
              type: SnackBarType.success,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OtpVerificationPage(email: _emailController.text),
              ),
            );
          } else if (state is AuthError) {
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthLogo(),
                  const SizedBox(height: 32),
                  const Text(
                    'Enter your email address to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthPrimaryButton(text: 'Reset Password', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
