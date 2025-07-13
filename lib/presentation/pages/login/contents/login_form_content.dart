import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../../../../common/navigation_service.dart';
import '../../../widgets/text_input_widget.dart';
import '../controllers/login_cubit.dart';

class LoginFormContent extends StatelessWidget {
  const LoginFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) {
        // Only listen when status changes to loaded or error
        return (previous.status != current.status) &&
            (current.status == RequestState.loaded ||
                current.status == RequestState.error);
      },
      listener: (context, state) {
        if (state.status == RequestState.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: kSecondaryColor,
            ),
          );
          // Navigate to home page using navigation service
          NavigationService.goToHome(context);
        }
        if (state.status == RequestState.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: kErrorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to your account",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Email Field
                TextInputWidget(
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) =>
                      context.read<LoginCubit>().updateEmail(value),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextInputWidget(
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        context.read<LoginCubit>().togglePasswordVisibility(),
                  ),
                  obscureText: !state.isPasswordVisible,
                  onChanged: (value) =>
                      context.read<LoginCubit>().updatePassword(value),
                  onFieldSubmitted: state.status == RequestState.loading
                      ? null
                      : (_) => context.read<LoginCubit>().login(),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.status == RequestState.loading
                        ? null
                        : () => context.read<LoginCubit>().login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.status == RequestState.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Demo credentials hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: kSecondaryColor.withValues(alpha: .3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: kSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo: admin@example.com / password123',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
