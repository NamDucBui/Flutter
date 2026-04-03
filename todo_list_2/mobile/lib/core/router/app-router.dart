import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/widgets/empty-state-widget.dart';
import '../../shared/widgets/responsive-layout-widget.dart';
import '../../features/notes/presentation/screens/notes-list-screen.dart';
import '../../features/notes/presentation/screens/note-editor-screen.dart';
import '../../features/folders/presentation/screens/folders-screen.dart';
import '../../features/search/presentation/screens/search-screen.dart';
import '../../features/settings/presentation/screens/settings-screen.dart';

part 'app-router.g.dart';

/// Application shell — delegates nav chrome to [ResponsiveLayoutWidget].
class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.notes_outlined),
      selectedIcon: Icon(Icons.notes),
      label: 'Notes',
    ),
    NavigationDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder),
      label: 'Folders',
    ),
    NavigationDestination(
      icon: Icon(Icons.search),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/notes');
      case 1:
        context.go('/folders');
      case 2:
        context.go('/search');
      case 3:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutWidget(
      body: child,
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => _onTabSelected(context, i),
      destinations: _destinations,
    );
  }
}

/// Placeholder screen for features not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyStateWidget(
        emoji: '🚧',
        title: title,
        subtitle: 'Coming soon',
      ),
    );
  }
}

/// go_router configuration with ShellRoute for bottom navigation.
/// Editor routes (/notes/create, /notes/:id) are outside the shell so they
/// render without the bottom navigation bar.
@riverpod
// ignore: deprecated_member_use_from_same_package
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/notes',
    routes: [
      // --- Editor routes (no bottom nav) ---
      GoRoute(
        path: '/notes/create',
        builder: (c, s) => const NoteEditorScreen(noteId: null),
      ),
      GoRoute(
        path: '/notes/:id',
        builder: (c, s) => NoteEditorScreen(noteId: s.pathParameters['id']),
      ),
      GoRoute(
        path: '/recently-deleted',
        builder: (c, s) => const _PlaceholderScreen('Recently Deleted'),
      ),

      // --- Shell routes (bottom nav) ---
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.toString();
          int idx = 0;
          if (location.startsWith('/folders')) {
            idx = 1;
          } else if (location.startsWith('/search')) {
            idx = 2;
          } else if (location.startsWith('/settings')) {
            idx = 3;
          }
          return AppShell(selectedIndex: idx, child: child);
        },
        routes: [
          GoRoute(
            path: '/notes',
            builder: (c, s) => const NotesListScreen(),
          ),
          GoRoute(
            path: '/folders',
            builder: (c, s) => const FoldersScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (c, s) => const SearchScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (c, s) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
