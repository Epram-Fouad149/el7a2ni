import 'package:el7a2ni/core/cubit/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final supabase = Supabase.instance.client;

  SettingsCubit() : super(SettingsInitialState());

  Future<void> logout() async {
    await supabase.auth.signOut();
    emit(SettingsInitialState());
  }
}
