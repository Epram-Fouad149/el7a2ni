import 'package:el7a2ni/core/cubit/settings/settings_cubit.dart';
import 'package:el7a2ni/core/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class SettingsViewModel {
  final SettingsCubit settingsCubit;
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();
  SettingsViewModel(this.settingsCubit);

  Future<void> logout(BuildContext context) async {
    settingsCubit.logout();
    await _prefsHelper.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
