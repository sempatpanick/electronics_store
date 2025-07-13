import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../contents/login_form_content.dart';
import '../controllers/login_cubit.dart';

class LoginSmallPage extends StatelessWidget {
  const LoginSmallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo/Brand Section
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Electronics Store',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Form
                const LoginFormContent(),

                // Footer
                const SizedBox(height: 24),
                Text(
                  '© 2024 Electronics Store',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: kTextSecondaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
