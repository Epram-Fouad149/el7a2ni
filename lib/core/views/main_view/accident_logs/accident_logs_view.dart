import 'package:el7a2ni/core/cubit/logs/logs_cubit.dart';
import 'package:el7a2ni/core/cubit/logs/logs_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AccidentLogsView extends StatelessWidget {
  const AccidentLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogsCubit()..fetchLogsData(),
      child: Scaffold(
        body: BlocBuilder<LogsCubit, LogsState>(
          builder: (context, state) {
            if (state is LogsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LogsFailureState) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is LogsSuccessState) {
              final logsData = state.logsData;

              if (logsData.isEmpty) {
                // 🎉 Fun UI when no accident logs exist
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events_rounded, size: 80, color: Colors.green),
                      const SizedBox(height: 20),
                      const Text(
                        'Woohoo! 🎉',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your driving record is cleaner than your browser history 😉 . . . You drive like a pro! 😎',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_moon_rounded, color: Colors.green),
                            SizedBox(width: 10),
                            Text(
                              'Safe Driver Badge',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 🚗 Fun-styled accident logs list
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text("Driver ID: ${state.user.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...logsData.map((log) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.red.shade50,
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        title: GestureDetector(
                          onTap: () {
                            final location = log['accident_location'] ?? '';
                            final regex = RegExp(r'Lat:([\d.\-]+),\s*Lon:([\d.\-]+)');
                            final match = regex.firstMatch(location);

                            if (match != null) {
                              final lat = match.group(1);
                              final lon = match.group(2);
                              final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
                              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid location format')),
                              );
                            }
                          },
                          child: Text(
                            '📍 Accident location: ${log['accident_location'] ?? 'Unknown location'}',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          '📅 Date: ${log['created_at'] ?? 'Unknown date'}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
