import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';

import 'common/router.dart';
import 'common/theme.dart';
import 'data/di/injection.dart';
import 'presentation/pages/main/controllers/main_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  if (!kIsWeb && !kIsWasm) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowMinSize(const Size(400, 700)); // Set your desired min size
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()),
      ],
      child: MaterialApp.router(
        title: 'Electronics Store',
        theme: theme,
        routerConfig: router,
      ),
    );
  }
}
