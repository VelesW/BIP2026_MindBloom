import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check if user is already logged in when app starts
class AuthCheckRequested extends AuthEvent {}

// Login with Email & Password
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Register a new account
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Trigger Google Sign-In
class GoogleSignInRequested extends AuthEvent {}

// Log out
class LogoutRequested extends AuthEvent {}
