import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jam_it/core/providers/current_user_notifier.dart';
import 'package:jam_it/core/theme/theme.dart';
import 'package:jam_it/features/auth/view/pages/login_page.dart';
import 'package:jam_it/features/auth/view/pages/signup_page.dart';
import 'package:jam_it/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:jam_it/features/home/view/pages/home_page.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreference();
  await container.read(authViewModelProvider.notifier).getData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const JamIt(),
    ),
  );
}

class JamIt extends ConsumerWidget {
  const JamIt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      routes: {
        "/signup": (context) => const SignupPage(),
        "/login": (context) => const LoginPage(),
      },
      title: 'Jam-IT',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      home: currenUser == null ? const SignupPage() : const HomePage(),
    );
  }
}
