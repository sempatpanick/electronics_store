import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../widgets/top_navigation.dart';
import '../contents/main_content.dart';

class MainLargePage extends StatelessWidget {
  const MainLargePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("MainLargePage");
    return Scaffold(
      body: Column(
        children: [
          const TopNavigation(),
          Expanded(
            child: Container(
              color: kBackgroundColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: const MainContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
