import 'package:el7a2ni/core/cubit/login/login_cubit.dart';
import 'package:el7a2ni/core/cubit/login/login_state.dart';
import 'package:el7a2ni/core/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final loginViewModel = LoginViewModel(loginCubit);
    final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccessState) {
            await _prefsHelper.setUserLoggedIn(true);
            Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
          }
          if (state is LoginFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.login,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(loginViewModel.emailController, "Email", Icons.email),
              const SizedBox(height: 16),
              _buildTextField(loginViewModel.passwordController, "Password", Icons.lock, isPassword: true),
              const SizedBox(height: 16),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  loginViewModel.login(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              // Sign Up Redirect Button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
