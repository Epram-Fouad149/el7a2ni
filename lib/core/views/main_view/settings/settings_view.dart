import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_app_state.dart';
import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:el7a2ni/core/cubit/settings/settings_cubit.dart';
import 'package:el7a2ni/core/views/main_view/settings/bluetooth_view_model.dart';
import 'package:el7a2ni/core/views/main_view/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = SettingsViewModel(context.read<SettingsCubit>());
    final bluetoothViewModel = BluetoothViewModel(
      cubit: context.read<BluetoothCubit>(),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bluetooth Section
              Card(
                margin: const EdgeInsets.only(bottom: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bluetooth Connection",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Bluetooth status and controls
                      BlocBuilder<BluetoothCubit, BluetoothAppState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Connection status
                              Row(
                                children: [
                                  Icon(
                                    state.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                                    color: state.isConnected ? Colors.blue : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Status: ${state.isConnected ? "Connected" : "Disconnected"}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: state.isConnected ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Loading indicator for connecting
                              if (state.isConnecting)
                                const Center(
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 8),
                                      Text("Connecting..."),
                                    ],
                                  ),
                                ),

                              // Device selection
                              if (!state.isConnected && !state.isConnecting)
                                ElevatedButton(
                                  onPressed: bluetoothViewModel.scanForDevices,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state.isScanning
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Scan for Devices",
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                ),

                              const SizedBox(height: 16),

                              // Devices list
                              if (!state.isConnected && !state.isConnecting && state.devices.isNotEmpty)
                                Container(
                                  constraints: const BoxConstraints(maxHeight: 300),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: state.devices.length,
                                    itemBuilder: (context, index) {
                                      final device = state.devices[index];
                                      return ListTile(
                                        title: Text(device.name ?? 'Unknown Device'),
                                        subtitle: Text(device.address),
                                        trailing: const Icon(Icons.bluetooth, color: Colors.blue),
                                        onTap: () => bluetoothViewModel.connectToDevice(device),
                                      );
                                    },
                                  ),
                                ),

                              // Disconnect and forget buttons if connected
                              if (state.isConnected)
                                Column(
                                  children: [
                                    // Disconnect button
                                    ElevatedButton(
                                      onPressed: bluetoothViewModel.disconnect,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        minimumSize: const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Disconnect",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),

                                    // Forget device button
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: bluetoothViewModel.forgetDevice,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        minimumSize: const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Forget Device",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),

                              // Display current notification if there's any
                              if (state.notification != null)
                                Card(
                                  margin: const EdgeInsets.only(top: 16),
                                  color: Colors.blue.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Notification from Arduino:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(state.notification!),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: bluetoothViewModel.sendYesResponse,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                child: const Text('Yes', style: TextStyle(fontSize: 16)),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: bluetoothViewModel.sendNoResponse,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                child: const Text('No', style: TextStyle(fontSize: 16)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Logout button
              ElevatedButton(
                onPressed: () {
                  settingsViewModel.logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
