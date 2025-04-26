import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:el7a2ni/core/cubit/home/home_cubit.dart';
import 'package:el7a2ni/core/cubit/login/login_cubit.dart';
import 'package:el7a2ni/core/cubit/navigation/navigation_cubit.dart';
import 'package:el7a2ni/core/cubit/profile/profile_cubit.dart';
import 'package:el7a2ni/core/cubit/registration/registration_cubit.dart';
import 'package:el7a2ni/core/cubit/settings/settings_cubit.dart';
import 'package:el7a2ni/core/cubit/splash/splash_cubit.dart';
import 'package:el7a2ni/core/utils/bluetooth_background_service.dart';
import 'package:el7a2ni/core/utils/notification_service.dart';
import 'package:el7a2ni/core/views/login/login_view.dart';
import 'package:el7a2ni/core/views/main_view/main_view.dart';
import 'package:el7a2ni/core/views/register/registration_view.dart';
import 'package:el7a2ni/core/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService().initialize();

  // Initialize background service
  await BluetoothBackgroundService.initializeService();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://qfqgpgjavfrcxdaetwog.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmcWdwZ2phdmZyY3hkYWV0d29nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMTM5NDksImV4cCI6MjA0ODg4OTk0OX0.hGfrvN9ARvBJxoBnhxcnMBvhmeOUwSOSWThUhUYBHek',
  );

  runApp(const El7a2niApp());
}

class El7a2niApp extends StatelessWidget {
  const El7a2niApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BluetoothCubit(), lazy: false),
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => RegistrationCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit(bluetoothCubit: context.read<BluetoothCubit>())),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'El7a2ni',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashView(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegistrationView(),
          '/main': (context) => const MainView(),
        },
      ),
    );
  }
}
