import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/theme/theme.dart';
import 'package:jam_it/features/auth/view/pages/login_page.dart';
import 'package:jam_it/features/auth/view/pages/signup_page.dart';
import 'package:jam_it/features/auth/viewmodel/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreference();
  final userModel =
      await container.read(authViewModelProvider.notifier).getData();
  print(userModel);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/signup": (context) => const SignupPage(),
        "/login": (context) => const LoginPage(),
      },
      title: 'Jam-IT',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      home: const SignupPage(),
    );
  }
}
