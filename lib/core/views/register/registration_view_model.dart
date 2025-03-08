import 'package:el7a2ni/core/cubit/registration/registration_cubit.dart';
import 'package:flutter/material.dart';

class RegistrationViewModel {
  final RegistrationCubit registrationCubit;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegistrationViewModel(this.registrationCubit);

  void register(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    registrationCubit.register(name, email, password);
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
