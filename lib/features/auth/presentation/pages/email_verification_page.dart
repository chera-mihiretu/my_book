import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_otpController.text.length == 8) {
      context.read<AuthBloc>().add(
        VerifyEmailRequested(email: widget.email, token: _otpController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            CustomLoading.show(context);
          } else {
            CustomLoading.hide();
          }

          if (state is EmailVerified) {
            CustomSnackBar.show(
              context,
              message: 'Email Verified successfully',
              type: SnackBarType.success,
            );
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          } else if (state is AuthError) {
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AuthLogo(),
                  const SizedBox(height: 32),
                  Text(
                    'Enter the 8-digit code sent to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: _otpController,
                    length: 8,
                    onCompleted: (pin) => _submit(),
                    defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withAlpha(128),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 45,
                      height: 56,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AuthPrimaryButton(text: 'Verify', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
