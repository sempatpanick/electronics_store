part of 'login_cubit.dart';

class LoginState {
  final RequestState status;
  final String? errorMessage;
  final String email;
  final String password;
  final bool isPasswordVisible;

  LoginState({
    this.status = RequestState.none,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });

  LoginState copyWith({
    RequestState? status,
    String? errorMessage,
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
