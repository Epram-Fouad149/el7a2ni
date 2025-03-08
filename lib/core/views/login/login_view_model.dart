import 'package:el7a2ni/core/cubit/login/login_cubit.dart';
import 'package:flutter/material.dart';

class LoginViewModel {
  final LoginCubit loginCubit;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginViewModel(this.loginCubit);

  // Method to trigger login
  void login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    // Simple validation: show feedback if any field is empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password')),
      );
      return;
    }

    // Proceed with login if both fields are filled
    loginCubit.login(email, password);
  }

  // Dispose method to clean up the controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
