part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthDidLoginState extends AuthState {}

class AuthLogout extends AuthState {}

class AuthGetProfile extends AuthState {
  // get profile while login
  _getProfile(String token) {}
}
