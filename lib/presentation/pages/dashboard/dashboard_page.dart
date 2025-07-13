import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contents/dashboard_content.dart';
import 'controllers/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DashboardCubit(), child: const DashboardContent());
  }
}
