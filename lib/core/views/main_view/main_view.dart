import 'package:el7a2ni/core/cubit/navigation/navigation_cubit.dart';
import 'package:el7a2ni/core/views/main_view/accident_logs/accident_logs_view.dart';
import 'package:el7a2ni/core/views/main_view/home/home_view.dart';
import 'package:el7a2ni/core/views/main_view/profile_info/profile_view.dart';
import 'package:el7a2ni/core/views/main_view/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const ProfileView(),
      const AccidentLogsView(), // Replace with your actual SearchPage widget
      const SettingsView(),
      // Replace with your actual SettingsPage widget
// Replace with your actual SettingsPage widget
    ];

    final List<String> titles = [
      "Home",
      "Profile Info",
      "Accident Logs",
      "Settings",
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
            appBar: AppBar(
              title: Text(titles[currentIndex]),
              centerTitle: true,
            ),
            body: pages[currentIndex],
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 1.5)]),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavigationCubit>().changePage(index);
                },
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile Info",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: "Accident Logs",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ],
              ),
            ));
      },
    );
  }
}
