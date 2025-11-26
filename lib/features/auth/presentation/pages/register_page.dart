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
import 'login_page.dart';

/// Modern Register Page with Light Book/eBook Theme - Stateless
class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final isLoading = useState(false);

    void handleRegister() {
      if (formKey.currentState!.validate()) {
        if (passwordController.text != confirmPasswordController.text) {
          CustomSnackBar.show(
            context,
            message: 'Passwords do not match',
            type: SnackBarType.error,
          );
          return;
        }

        isLoading.value = true;
        context.read<AuthBloc>().add(
          RegisterEvent(
            email: emailController.text.trim(),
            password: passwordController.text,
            name: nameController.text.trim(),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            isLoading.value = false;
            CustomSnackBar.show(
              context,
              message:
                  'Registration successful! Veryify please verify your email.',
              type: SnackBarType.success,
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
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
                        title: 'Create Account',
                        subtitle: 'Sign up to get started',
                      ),
                      const SizedBox(height: 24),

                      // Name Input
                      AuthTextField(
                        controller: nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        validator: Validators.name,
                      ),
                      const SizedBox(height: 16),

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
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Input
                      AuthTextField(
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscureConfirmPassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            obscureConfirmPassword.value =
                                !obscureConfirmPassword.value;
                          },
                        ),
                        validator: (value) => Validators.confirmPassword(
                          value,
                          passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Button
                      AuthPrimaryButton(
                        text: 'Sign Up',
                        onPressed: handleRegister,
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

                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Color(0xFF6B4EFF),
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
