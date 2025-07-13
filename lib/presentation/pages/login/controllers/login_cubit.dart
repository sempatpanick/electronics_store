import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  Future<void> login() async {
    // Validate inputs
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Please fill in all fields',
        ),
      );
      return;
    }

    if (!_validateEmail(state.email)) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }

    if (!_validatePassword(state.password)) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Password must be at least 6 characters long',
        ),
      );
      return;
    }

    // Start loading
    emit(state.copyWith(status: RequestState.loading, errorMessage: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, accept any valid email/password combination
      if (state.email == 'admin@example.com' &&
          state.password == 'password123') {
        emit(state.copyWith(status: RequestState.loaded));
        // Here you would typically navigate to home page or store auth token
      } else {
        emit(
          state.copyWith(
            status: RequestState.error,
            errorMessage: 'Invalid email or password',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'An error occurred. Please try again.',
        ),
      );
    }
  }

  void resetState() {
    emit(LoginState());
  }
}
