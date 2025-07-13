import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/navigation_service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  void setSelectedNavigationIndex(int index) {
    emit(state.copyWith(selectedNavigationIndex: index));
  }

  void navigateToRoute(int index, BuildContext context) {
    // Map index to route for navigation
    final routeMap = {
      0: '/',
      1: '/products',
      2: '/favorites',
      3: '/cart',
      4: '/orders',
      5: '/more',
    };

    final targetRoute = routeMap[index] ?? '/';
    NavigationService.goToRoute(context, targetRoute, isReplace: true);
  }
}
