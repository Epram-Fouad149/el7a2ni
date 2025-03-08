import 'dart:io';

import 'package:el7a2ni/core/cubit/profile/profile_cubit.dart';
import 'package:el7a2ni/core/cubit/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel {
  final ProfileCubit profileCubit;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  ProfileViewModel(this.profileCubit);

  void fetchUserData() async {
    await profileCubit.fetchUserData();
    final profileData =
        profileCubit.state is ProfileSuccessState ? (profileCubit.state as ProfileSuccessState).profileData : null;

    if (profileData != null) {
      phoneController.text = profileData['phone'] ?? '';
      bloodTypeController.text = profileData['blood_type'] ?? '';
      nameController.text = profileData['name'] ?? '';
    }
  }

  Future<void> pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileCubit.uploadImage(File(pickedFile.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
  }

  void updateAllFields() {
    profileCubit.updateUserData(
      phoneNumber: phoneController.text,
      bloodType: bloodTypeController.text,
    );
  }
}
