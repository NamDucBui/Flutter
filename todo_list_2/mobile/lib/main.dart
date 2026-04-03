import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app-router.dart';
import 'core/theme/app-theme.dart';
import 'core/database/objectbox-service.dart';
import 'features/settings/presentation/providers/settings-provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxService.initialize();
  runApp(const ProviderScope(child: NotesApp()));
}

/// Root application widget.
class NotesApp extends ConsumerWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode =
        ref.watch(appThemeModeProvider).value ?? ThemeMode.system;
    return MaterialApp.router(
      title: 'Notes',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
