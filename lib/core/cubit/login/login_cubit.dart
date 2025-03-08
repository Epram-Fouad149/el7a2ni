import 'package:el7a2ni/core/cubit/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoadingState());

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // If response.user is null, there was an error in login
      if (response.user == null) {
        emit(LoginFailureState('Invalid email or password.'));
      } else {
        emit(LoginSuccessState());
      }
    } catch (e) {
      emit(LoginFailureState('An error occurred: $e'));
    }
  }
}
