# Phase 6: UI Polish, Theme & Testing

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** ✅ Complete | **Priority:** P2 | **Est:** 16h
**Blocked by:** Phase 5 (Search & Filtering)

## Overview

Polish toàn bộ UI/UX, implement responsive layout cho tablet/desktop, dark/light theme persistence, animations, accessibility, và viết unit + widget tests cho core features.

## Key Insights

- Material 3 dynamic color (Android 12+): dùng `ColorScheme.fromSeed` fallback cho older devices
- Responsive: mobile = bottom nav, tablet = NavigationRail, desktop = NavigationDrawer permanent
- Animations: `AnimatedSwitcher` cho view toggle, `Hero` cho note card → editor transition
- Theme persistence: lưu vào `SharedPreferences` key `'theme_mode'`
- Test priority: repository logic > providers > widgets (theo tầng Clean Architecture)
- `flutter_test` + `mocktail` cho mocking repositories

## Requirements

### Functional
- [ ] Theme toggle (System/Light/Dark) persist qua app restart
- [ ] Responsive layout: mobile nav bar, tablet NavigationRail, desktop permanent drawer
- [ ] Smooth animations: list item transitions, FAB animation, color picker
- [ ] `Hero` animation: note card → editor
- [ ] Undo delete: Snackbar với "Undo" action (5 seconds)
- [ ] Settings screen: theme toggle, sort order, about
- [ ] Sort options: Modified date ↓↑, Created date ↓↑, Title A-Z
- [ ] Empty state illustrations for: All Notes, Folder, Search, Recently Deleted
- [ ] Keyboard shortcuts (Desktop): Ctrl+N new note, Ctrl+F search, Escape close
- [ ] Accessibility: semantic labels, sufficient contrast, min 44px tap targets

### Non-functional
- Unit test coverage ≥ 70% cho domain + data layers
- Widget tests cho critical screens (list, editor)
- No lint warnings (`flutter analyze` clean)
- Performance: 60fps scrolling on 100+ notes

## Architecture

```
lib/
├── features/
│   └── settings/
│       ├── presentation/
│       │   ├── providers/
│       │   │   └── settings-provider.dart    # theme + sort prefs
│       │   ├── screens/
│       │   │   └── settings-screen.dart
│       │   └── widgets/
│       │       └── theme-toggle-widget.dart
├── shared/
│   ├── widgets/
│   │   ├── empty-state-widget.dart          # (Phase 1 stub → fill here)
│   │   ├── responsive-layout-widget.dart    # mobile/tablet/desktop
│   │   └── undo-delete-mixin.dart           # snackbar undo logic
│   └── utils/
│       └── responsive-breakpoints.dart

test/
├── features/
│   ├── notes/
│   │   ├── data/
│   │   │   └── note-repository-impl-test.dart
│   │   ├── domain/
│   │   │   └── note-entity-test.dart
│   │   └── presentation/
│   │       └── notes-list-screen-test.dart
│   ├── search/
│   │   └── search-provider-test.dart
│   └── folders/
│       └── folder-repository-impl-test.dart
└── core/
    └── database/
        └── isar-database-service-test.dart
```

## Implementation Steps

### 1. Settings Provider (Theme + Sort)
```dart
// lib/features/settings/presentation/providers/settings-provider.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'settings-provider.g.dart';

enum NotesSortOrder { modifiedDesc, modifiedAsc, createdDesc, titleAsc }

@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

@riverpod
class NotesSortPreference extends _$NotesSortPreference {
  static const _key = 'notes_sort';

  @override
  Future<NotesSortOrder> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return NotesSortOrder.values.firstWhere(
      (o) => o.name == saved,
      orElse: () => NotesSortOrder.modifiedDesc,
    );
  }

  Future<void> setOrder(NotesSortOrder order) async {
    state = AsyncValue.data(order);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, order.name);
  }
}
```

### 2. Responsive Layout Widget
```dart
// lib/shared/widgets/responsive-layout-widget.dart
class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  const ResponsiveLayoutWidget({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return _DesktopLayout(this);
    if (width >= 600) return _TabletLayout(this);
    return _MobileLayout(this);
  }
}

class _MobileLayout extends StatelessWidget {
  final ResponsiveLayoutWidget config;
  const _MobileLayout(this.config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: config.body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: config.selectedIndex,
        onDestinationSelected: config.onDestinationSelected,
        destinations: config.destinations,
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final ResponsiveLayoutWidget config;
  const _TabletLayout(this.config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: config.selectedIndex,
            onDestinationSelected: config.onDestinationSelected,
            labelType: NavigationRailLabelType.selected,
            destinations: config.destinations
                .map((d) => NavigationRailDestination(
                      icon: d.icon,
                      label: Text((d.label as Text).data ?? ''),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: config.body),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ResponsiveLayoutWidget config;
  const _DesktopLayout(this.config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: config.selectedIndex,
            onDestinationSelected: config.onDestinationSelected,
            children: [
              const SizedBox(height: 16),
              ...config.destinations.map((d) => NavigationDrawerDestination(
                    icon: d.icon,
                    label: d.label,
                  )),
            ],
          ),
          Expanded(child: config.body),
        ],
      ),
    );
  }
}
```

### 3. Undo Delete Snackbar
```dart
// lib/shared/widgets/undo-delete-mixin.dart
mixin UndoDeleteMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showUndoDeleteSnackbar({
    required String message,
    required VoidCallback onUndo,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: onUndo,
        ),
      ),
    );
  }
}
```

### 4. Empty State Widget (with illustrations)
```dart
// lib/shared/widgets/empty-state-widget.dart
enum EmptyStateType { allNotes, folder, search, recentlyDeleted }

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? customMessage;

  const EmptyStateWidget({
    super.key,
    this.type = EmptyStateType.allNotes,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final (emoji, title, subtitle) = _content(type);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(customMessage ?? subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (String, String, String) _content(EmptyStateType type) => switch (type) {
    EmptyStateType.allNotes => ('📝', 'No Notes Yet', 'Tap + to create your first note'),
    EmptyStateType.folder => ('📁', 'Empty Folder', 'Move notes here from All Notes'),
    EmptyStateType.search => ('🔍', 'No Results', 'Try different keywords or remove filters'),
    EmptyStateType.recentlyDeleted => ('🗑️', 'Nothing Here', 'Deleted notes appear here for 30 days'),
  };
}
```

### 5. Settings Screen
```dart
// lib/features/settings/presentation/screens/settings-screen.dart
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(appThemeModeProvider);
    final sortAsync = ref.watch(notesSortPreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Theme section
          const _SectionHeader(title: 'Appearance'),
          themeModeAsync.when(
            loading: () => const ListTile(title: Text('Theme')),
            error: (_, __) => const SizedBox.shrink(),
            data: (mode) => ListTile(
              title: const Text('Theme'),
              subtitle: Text(switch (mode) {
                ThemeMode.system => 'System',
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
              }),
              trailing: SegmentedButton<ThemeMode>(
                selected: {mode},
                onSelectionChanged: (s) =>
                    ref.read(appThemeModeProvider.notifier).setMode(s.first),
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto)),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
                ],
              ),
            ),
          ),
          const Divider(),
          // Sort section
          const _SectionHeader(title: 'Notes'),
          sortAsync.when(
            loading: () => const ListTile(title: Text('Sort by')),
            error: (_, __) => const SizedBox.shrink(),
            data: (sort) => ListTile(
              title: const Text('Sort by'),
              subtitle: Text(sort.displayName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSortPicker(context, ref, sort),
            ),
          ),
          const Divider(),
          // About section
          const _SectionHeader(title: 'About'),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }

  void _showSortPicker(BuildContext ctx, WidgetRef ref, NotesSortOrder current) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: NotesSortOrder.values.map((order) => RadioListTile<NotesSortOrder>(
          value: order,
          groupValue: current,
          title: Text(order.displayName),
          onChanged: (v) {
            if (v != null) {
              ref.read(notesSortPreferenceProvider.notifier).setOrder(v);
              Navigator.pop(ctx);
            }
          },
        )).toList(),
      ),
    );
  }
}

extension on NotesSortOrder {
  String get displayName => switch (this) {
    NotesSortOrder.modifiedDesc => 'Date Modified ↓',
    NotesSortOrder.modifiedAsc => 'Date Modified ↑',
    NotesSortOrder.createdDesc => 'Date Created ↓',
    NotesSortOrder.titleAsc => 'Title A→Z',
  };
}
```

### 6. Keyboard Shortcuts (Desktop)
```dart
// In note-editor-screen.dart wrap with:
CallbackShortcuts(
  bindings: {
    const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
        context.push('/notes/new'),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
        context.go('/search'),
    const SingleActivator(LogicalKeyboardKey.escape): () =>
        context.pop(),
  },
  child: Focus(autofocus: true, child: /* scaffold */),
)
```

### 7. Unit Tests
```dart
// test/features/notes/domain/note-entity-test.dart
void main() {
  group('NoteEntity', () {
    final base = NoteEntity(
      id: 'test-uuid',
      title: 'Test',
      plainContent: 'Hello',
      richContent: '{}',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      isPinned: false,
      isDeleted: false,
      color: '#FFFFFF',
    );

    test('copyWith updates updatedAt', () {
      final updated = base.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.id, base.id); // ID unchanged
      expect(updated.updatedAt.isAfter(base.updatedAt), isTrue);
    });

    test('copyWith preserves unmodified fields', () {
      final updated = base.copyWith(isPinned: true);
      expect(updated.plainContent, base.plainContent);
      expect(updated.isPinned, true);
    });
  });
}
```

```dart
// test/features/notes/data/note-repository-impl-test.dart
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNoteDatasource extends Mock implements NoteLocalDatasource {}

void main() {
  late NoteRepositoryImpl repo;
  late MockNoteDatasource mockDs;

  setUp(() {
    mockDs = MockNoteDatasource();
    repo = NoteRepositoryImpl(mockDs);
  });

  test('createNote calls datasource.save', () async {
    final note = NoteEntity(/* ... */);
    when(() => mockDs.save(any())).thenAnswer((_) async {});
    await repo.createNote(note);
    verify(() => mockDs.save(any())).called(1);
  });

  test('deleteNote calls softDelete', () async {
    when(() => mockDs.softDelete(any())).thenAnswer((_) async {});
    when(() => mockDs.getByUuid(any())).thenAnswer((_) async => NoteIsarModel()..id = 1);
    await repo.deleteNote('test-uuid');
    verify(() => mockDs.softDelete(1)).called(1);
  });
}
```

```dart
// test/features/search/search-provider-test.dart
void main() {
  test('SearchHighlightTextWidget highlights query', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchHighlightTextWidget(
          text: 'Hello Flutter World',
          query: 'Flutter',
        ),
      ),
    ));
    // Verify RichText contains highlighted span
    final richText = tester.widget<RichText>(find.byType(RichText).first);
    final spans = (richText.text as TextSpan).children!;
    expect(spans.any((s) => (s as TextSpan).style?.backgroundColor != null), isTrue);
  });
}
```

### 8. Flutter Analyze & Fix
```bash
# Run before commit
flutter analyze
flutter test --coverage
# Coverage report
dart pub global run coverage:format_coverage --lcov \
  --in=coverage/lcov.info --out=coverage/lcov.info --packages=.dart_tool/package_config.json
```

## Todo List

- [ ] Implement `settings-provider.dart` (theme + sort persistence)
- [ ] Implement `settings-screen.dart` với theme SegmentedButton + sort picker
- [ ] Implement `responsive-layout-widget.dart` (mobile/tablet/desktop)
- [ ] Update `main.dart` → connect `appThemeModeProvider` to `themeMode`
- [ ] Implement `empty-state-widget.dart` với 4 variants
- [ ] Implement `undo-delete-mixin.dart` → apply trong notes list screen
- [ ] Add keyboard shortcuts cho Desktop (Ctrl+N, Ctrl+F, Escape)
- [ ] Add `Hero` widget wrapping note card + editor
- [ ] Add `AnimatedSwitcher` cho grid/list toggle
- [ ] Add semantic labels cho accessibility (Semantics widgets)
- [ ] Apply sort order từ settings vào `note-local-datasource.dart`
- [ ] Write unit tests: `note-entity-test.dart`
- [ ] Write unit tests: `note-repository-impl-test.dart`
- [ ] Write unit tests: `folder-repository-impl-test.dart`
- [ ] Write widget test: `notes-list-screen-test.dart`
- [ ] Write widget test: `search-highlight-text-widget-test.dart`
- [ ] Run `flutter analyze` → fix all warnings
- [ ] Run `flutter test` → all pass
- [ ] Test trên: iOS Simulator, Android Emulator, Chrome, macOS
- [ ] Performance: scroll 100+ notes @ 60fps (use Flutter DevTools)

## Success Criteria

- `flutter analyze` returns 0 issues
- `flutter test` all tests pass
- Theme toggle persists sau hot restart + full restart
- Responsive: mobile bottom nav, tablet rail, desktop drawer — tất cả đúng
- Undo delete hoạt động trong 5 seconds
- Empty states hiển thị đúng cho mỗi context
- Keyboard shortcuts hoạt động trên macOS/Windows
- 60fps scrolling verified bằng Flutter DevTools

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Isar không support Web | Medium | Đã note từ Phase 1 — implement in-memory fallback hoặc skip Web |
| Hero animation conflict với bottom sheet | Low | Wrap riêng Hero với unique tag |
| `shared_preferences` chậm trên first load | Low | Use `AsyncValue.data` với loading fallback |
| Test coverage thấp trên data layer | Medium | Ưu tiên test repository impl với mock datasource |
| macOS desktop sandbox permissions | Low | Configure `macos/Runner/DebugProfile.entitlements` |

## Security Considerations

- Settings store: `SharedPreferences` (không sensitive) — OK
- Không lưu bất kỳ PII trong settings
- Image files trong app documents — không expose qua URL scheme

## Next Steps (Deferred Features)

Sau MVP, scope có thể mở rộng:
- **Phase 7:** Cloud Sync (Supabase + Auth)
- **Phase 8:** Export PDF/Markdown
- **Phase 9:** Handwriting Canvas (perfect_freehand)
- **Phase 10:** Note lock (biometric)
