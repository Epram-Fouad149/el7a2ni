import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_app_state.dart';
import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart'; // Add this import
import 'package:el7a2ni/core/cubit/profile/profile_cubit.dart';
import 'package:el7a2ni/core/cubit/profile/profile_state.dart';
import 'package:el7a2ni/core/views/main_view/profile_info/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = ProfileViewModel(
      context.read<ProfileCubit>(),
      bluetoothCubit: context.read<BluetoothCubit>(), // Pass BluetoothCubit
    );
    profileViewModel.fetchUserData();

    return Scaffold(
      body: Center(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileSuccessState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: state.profileData?['profile_image'] != null
                              ? NetworkImage(state.profileData!['profile_image'])
                              : null,
                          child: state.profileData?['profile_image'] == null
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              profileViewModel.pickAndUploadImage(context);
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hello, ${profileViewModel.nameController.text}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: profileViewModel.nameController,
                      label: "Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: profileViewModel.phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: profileViewModel.bloodTypeController,
                      label: "Blood Type",
                      icon: Icons.bloodtype,
                    ),
                    const SizedBox(height: 16),
                    _buildGenderDropdown(
                      selectedGender: profileViewModel.selectedGender,
                      onChanged: profileViewModel.onGenderChanged,
                    ),
                    const SizedBox(height: 16),
                    // Add Age field
                    _buildTextField(
                      controller: profileViewModel.ageController,
                      label: "Age",
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: profileViewModel.nationalNumberController,
                      label: "National Number",
                      icon: Icons.numbers,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: profileViewModel.updateAllFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Update All Fields",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add Send to Vehicle button
                    BlocBuilder<BluetoothCubit, BluetoothAppState>(
                      builder: (context, bluetoothState) {
                        return ElevatedButton(
                          onPressed:
                              bluetoothState.isConnected ? () => profileViewModel.sendProfileToArduino(context) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                bluetoothState.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Send to Vehicle",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            if (state is ProfileFailureState) {
              return Center(child: Text(state.errorMessage));
            }

            return const Center(child: Text("Unknown state"));
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown({
    required String selectedGender,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedGender.isNotEmpty ? selectedGender : null,
      items: ['Male', 'Female'].map((gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
