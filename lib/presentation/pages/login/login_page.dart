import 'package:flutter/material.dart';

import 'responsives/login_large_page.dart';
import 'responsives/login_small_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Use large layout for screens wider than 800px
    if (size.width > 800) {
      return const LoginLargePage();
    } else {
      return const LoginSmallPage();
    }
  }
}
