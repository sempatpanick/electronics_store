import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../dashboard/controllers/dashboard_cubit.dart';
import 'responsives/main_large_page.dart';
import 'responsives/main_small_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => DashboardCubit())],
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: size.width >= 600 ? const MainLargePage() : const MainSmallPage(),
      ),
    );
  }
}
