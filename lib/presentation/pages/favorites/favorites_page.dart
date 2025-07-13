import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contents/favorites_content.dart';
import 'controllers/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoritesCubit(),
        ),
      ],
      child: const FavoritesContent(),
    );
  }
}
