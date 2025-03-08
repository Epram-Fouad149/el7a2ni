import 'package:el7a2ni/core/cubit/registration/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitialState());

  Future<void> register(String name, String email, String password) async {
    emit(RegistrationLoadingState());

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        await Supabase.instance.client.from('profiles').insert({'id': userId, "name": name});

        emit(RegistrationSuccessState());
      } else {
        emit(const RegistrationFailureState('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(RegistrationFailureState('Unexpected error: ${e.toString()}'));
    }
  }
}
