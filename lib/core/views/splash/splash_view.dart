import 'package:el7a2ni/core/cubit/splash/splash_cubit.dart';
import 'package:el7a2ni/core/cubit/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = BlocProvider.of<SplashCubit>(context);
    final splashViewModel = SplashViewModel(splashCubit);

    splashViewModel.startSplashNavigation();

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is SplashNavigatedState) {
          final isLoggedIn = await splashViewModel.isUserLoggedIn();
          isLoggedIn
              ? Navigator.pushReplacementNamed(context, '/main')
              : Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo with zoom in effect and rotation
              TweenAnimationBuilder(
                tween: Tween(begin: 0.5, end: 1.0),
                duration: const Duration(seconds: 1),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: const RotationTransition(
                      turns: AlwaysStoppedAnimation(15 / 360),
                      child: Icon(
                        Icons.car_crash,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Fade transition for text
              const Text(
                "Welcome to El7a2ni",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              // Circular Progress Indicator with animated color
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
