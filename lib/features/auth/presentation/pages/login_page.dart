import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_welcome_text.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/google_signin_button.dart';
import 'register_page.dart';

/// Modern Login Page with Light Book/eBook Theme - Stateless
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final obscurePassword = useState(true);
    final isLoading = useState(false);

    void handleLogin() {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        context.read<AuthBloc>().add(
          LoginEvent(
            email: emailController.text.trim(),
            password: passwordController.text,
          ),
        );
      }
    }

    void handleGoogleSignIn() {
      CustomSnackBar.show(
        context,
        message: 'Google Sign In - Coming Soon',
        type: SnackBarType.warning,
      );
    }

    void handleForgotPassword() {
      CustomSnackBar.show(
        context,
        message: 'Forgot Password - Coming Soon',
        type: SnackBarType.warning,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            isLoading.value = false;
            CustomSnackBar.show(
              context,
              message: 'Login successful!',
              type: SnackBarType.success,
            );
            // TODO: Navigate to home
          } else if (state is AuthError) {
            isLoading.value = false;
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Section
                      const AuthLogo(),
                      const SizedBox(height: 32),

                      // Welcome Text
                      const AuthWelcomeText(
                        title: 'Welcome Back',
                        subtitle: 'Sign in to continue',
                      ),
                      const SizedBox(height: 24),

                      // Email Input
                      AuthTextField(
                        controller: emailController,
                        labelText: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      AuthTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscurePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).colorScheme.onSurface
                                .withAlpha((0.6 * 255).toInt()),
                          ),
                          onPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 8),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: handleForgotPassword,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      AuthPrimaryButton(
                        text: 'Sign In',
                        onPressed: handleLogin,
                        isLoading: isLoading.value,
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      const AuthDivider(),
                      const SizedBox(height: 16),

                      // Google Sign In Button
                      GoogleSignInButton(
                        onPressed: handleGoogleSignIn,
                        isLoading: isLoading.value,
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface
                                    .withAlpha((0.7 * 255).toInt()),
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              child: Text(
                                'Create New',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
