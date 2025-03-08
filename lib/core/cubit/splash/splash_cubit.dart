import 'package:el7a2ni/core/cubit/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitialState());

  void navigate() {
    emit(SplashNavigatedState());
  }
}
