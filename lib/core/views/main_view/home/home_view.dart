import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_app_state.dart';
import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:el7a2ni/core/cubit/home/home_cubit.dart';
import 'package:el7a2ni/core/cubit/home/home_state.dart';
import 'package:el7a2ni/core/views/main_view/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = HomeViewModel(context.read<HomeCubit>());
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final theme = Theme.of(context);

    // Calculate safe ratios for different screen sizes
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.02;

    // Adjust button size based on screen width but with minimum/maximum constraints
    final buttonSize = size.width * 0.18;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with connection status
                  BlocBuilder<BluetoothCubit, BluetoothAppState>(
                    builder: (context, bluetoothState) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                bluetoothState.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                                color: bluetoothState.isConnected ? Colors.blue : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Vehicle System",
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      bluetoothState.isConnected
                                          ? "Connected and ready"
                                          : "Disconnected - Connect in Settings",
                                      style: TextStyle(
                                        color: bluetoothState.isConnected ? Colors.green : Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: verticalSpacing),

                  // Main content - Help request section
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate proportional sizes based on available space
                        final iconSize = constraints.maxWidth * 0.2;
                        const titleSize = 24.0;
                        const descSize = 16.0;

                        return Center(
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: constraints.maxHeight * 0.05),

                                    // Emergency icon
                                    Icon(
                                      Icons.emergency,
                                      size: iconSize,
                                      color: state is HomeSendingHelpState
                                          ? Colors.orange
                                          : state is HomeSentHelpState
                                              ? Colors.green
                                              : Colors.red.shade700,
                                    ),

                                    SizedBox(height: constraints.maxHeight * 0.05),

                                    // Title
                                    Text(
                                      state is HomeSendingHelpState
                                          ? "Sending Request..."
                                          : state is HomeSentHelpState
                                              ? "Help Request Sent!"
                                              : "Need Assistance?",
                                      style: const TextStyle(
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    SizedBox(height: constraints.maxHeight * 0.03),

                                    // Description
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                                      child: Text(
                                        state is HomeSendingHelpState
                                            ? "Communicating with vehicle systems..."
                                            : state is HomeSentHelpState
                                                ? "Your request has been received"
                                                : "Press the button below to request help from nearby emergency services",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: descSize,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: constraints.maxHeight * 0.07),

                                    // Error message if any
                                    if (state is HomeErrorState)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          state.errorMessage,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),

                                    // Help request button
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 20),
                                      width: buttonSize,
                                      height: buttonSize,
                                      child: FloatingActionButton(
                                        backgroundColor: state is HomeSendingHelpState || state is HomeSentHelpState
                                            ? Colors.grey
                                            : Colors.red.shade700,
                                        onPressed: state is HomeSendingHelpState || state is HomeSentHelpState
                                            ? null
                                            : homeViewModel.requestHelp,
                                        child: Text(
                                          "SOS",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: buttonSize * 0.3,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: constraints.maxHeight * 0.05),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Safety tip footer
                  Card(
                    elevation: 2,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Safety Tip",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Only use the emergency button in case of actual emergencies. Your location will be shared with emergency services.",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
