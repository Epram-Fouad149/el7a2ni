import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final User user;
  final Map<String, dynamic>? profileData;

  ProfileSuccessState({
    required this.user,
    required this.profileData,
  });
}

class ProfileFailureState extends ProfileState {
  final String errorMessage;

  ProfileFailureState({required this.errorMessage});
}
