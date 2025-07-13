part of 'main_cubit.dart';

class MainState {
  final int selectedNavigationIndex;
  final bool isNavigationExpanded;

  MainState({
    this.selectedNavigationIndex = 0,
    this.isNavigationExpanded = true,
  });

  MainState copyWith({
    int? selectedNavigationIndex,
    bool? isNavigationExpanded,
  }) {
    return MainState(
      selectedNavigationIndex:
          selectedNavigationIndex ?? this.selectedNavigationIndex,
      isNavigationExpanded: isNavigationExpanded ?? this.isNavigationExpanded,
    );
  }
}
