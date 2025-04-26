import 'dart:io';

import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart'; // Add this import
import 'package:el7a2ni/core/cubit/profile/profile_cubit.dart';
import 'package:el7a2ni/core/cubit/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel {
  final ProfileCubit profileCubit;
  final BluetoothCubit? bluetoothCubit; // Optional because we'll pass it explicitly

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedGender = '';
  final TextEditingController nationalNumberController = TextEditingController();

  // Add age controller
  final TextEditingController ageController = TextEditingController();

  ProfileViewModel(this.profileCubit, {this.bluetoothCubit});

  void fetchUserData() async {
    await profileCubit.fetchUserData();
    final profileData =
        profileCubit.state is ProfileSuccessState ? (profileCubit.state as ProfileSuccessState).profileData : null;

    if (profileData != null) {
      phoneController.text = profileData['phone'] ?? '';
      bloodTypeController.text = profileData['blood_type'] ?? '';
      nameController.text = profileData['name'] ?? '';
      selectedGender = profileData['gender'] ?? '';
      nationalNumberController.text = profileData['national_number'] ?? '';
      ageController.text = profileData['age']?.toString() ?? '';
    }
  }

  void onGenderChanged(String? gender) {
    if (gender != null) {
      selectedGender = gender;
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
      gender: selectedGender,
      nationalNumber: nationalNumberController.text,
      age: ageController.text.isNotEmpty ? int.tryParse(ageController.text) : null,
    );
  }

  // Add method to send data to Arduino
  Future<bool> sendProfileToArduino(BuildContext context) async {
    if (bluetoothCubit == null || !(bluetoothCubit!.state.isConnected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bluetooth not connected. Please connect in Settings.")),
      );
      return false;
    }

    // Get user ID from profile data
    final userId =
        profileCubit.state is ProfileSuccessState ? (profileCubit.state as ProfileSuccessState).user.id : "UNKNOWN";

    final name = nameController.text;
    final gender = selectedGender;
    final bloodType = bloodTypeController.text;
    final age = ageController.text.isEmpty ? "0" : ageController.text;
    final nationalNumber = nationalNumberController.text;

    final dataToSend = "$userId,$name,$gender,$bloodType,$age,$nationalNumber";

    // Send data to Arduino
    bluetoothCubit!.sendResponse(dataToSend);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile data sent to vehicle")),
    );

    return true;
  }
}
