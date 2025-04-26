import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  final supabase = Supabase.instance.client;

  Future<void> fetchUserData() async {
    emit(ProfileLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final response = await supabase.from('profiles').select().eq('id', user.id).single();

        emit(ProfileSuccessState(user: user, profileData: response));
      } else {
        emit(ProfileFailureState(errorMessage: "User not found"));
      }
    } catch (e) {
      emit(ProfileFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      emit(ProfileLoadingState());

      final user = supabase.auth.currentUser;
      if (user != null) {
        final fileName = 'public/${user.email}.jpg';

        //TODO moshklt el profile pic
        await supabase.storage.from('profile-pictures').remove([fileName]);
        //msh rady y3ml hnaa remove msh 3arf leh
        await Future.delayed(const Duration(milliseconds: 500));
        await supabase.storage.from('profile-pictures').upload(fileName, imageFile);

        final imageUrl = supabase.storage.from('profile-pictures').getPublicUrl(fileName);

        await supabase.from('profiles').upsert({
          'id': user.id,
          'profile_image': imageUrl,
        });

        await fetchUserData(); // Refresh user data
      }
    } catch (e) {
      emit(ProfileFailureState(errorMessage: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<void> updateUserData({
    String? phoneNumber,
    String? bloodType,
    String? gender,
    String? nationalNumber,
    int? age,
  }) async {
    try {
      emit(ProfileLoadingState());

      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('profiles').upsert({
          'id': user.id,
          'phone': phoneNumber,
          'blood_type': bloodType,
          'gender': gender,
          'national_number': nationalNumber,
          if (age != null) 'age': age,
        });

        await fetchUserData(); // Refresh data
      }
    } catch (e) {
      emit(ProfileFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    emit(ProfileInitialState());
  }
}
