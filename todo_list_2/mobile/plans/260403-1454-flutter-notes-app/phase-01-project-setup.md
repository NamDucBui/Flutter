# Phase 1: Project Setup & Architecture

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** Pending | **Priority:** P1 | **Est:** 8h

## Overview

Bootstrap Flutter project trong `mobile/` subdirectory với clean architecture, configure tất cả dependencies, setup code generation, và establish folder structure chuẩn cho toàn dự án.

**Workspace context:** Flutter code lives in `mobile/` — run all Flutter commands from `mobile/` directory.

## Key Insights

- Fresh start — không có Flutter code trước đó
- All platforms: iOS, Android, Web, macOS, Windows, Linux
- `isar_flutter_libs` cần platform-specific setup (không support Web natively → dùng `isar_web` fallback)
- Riverpod code generation cần `build_runner` chạy trước khi build
- `go_router` shell routes cho bottom navigation bar

## Requirements

### Functional
- [ ] Flutter project khởi tạo tại `mobile/` với tên `notes_app`
- [ ] Tất cả packages cài đặt và resolve conflict-free
- [ ] Code generation (`build_runner`) chạy thành công
- [ ] App chạy được trên iOS, Android, Web (macOS optional)
- [ ] Bottom navigation: All Notes / Folders / Search / Settings
- [ ] Light/Dark theme toggle hoạt động

### Non-functional
- Flutter SDK ≥ 3.19.0, Dart ≥ 3.3.0
- Tất cả file ≤ 200 LOC (modularize nếu vượt)
- Kebab-case file naming

## Architecture

```
mobile/lib/
├── core/
│   ├── database/
│   │   └── isar-database-service.dart       # Isar singleton
│   ├── router/
│   │   └── app-router.dart                  # go_router config
│   └── theme/
│       ├── app-theme.dart                   # ThemeData export
│       ├── light-theme.dart
│       └── dark-theme.dart
├── features/
│   ├── notes/
│   ├── folders/
│   ├── tags/
│   └── search/
├── shared/
│   └── widgets/
│       └── empty-state-widget.dart
└── main.dart
```

## Related Code Files

### Create
- `mobile/lib/main.dart` — ProviderScope + MaterialApp.router
- `mobile/lib/core/router/app-router.dart` — go_router ShellRoute
- `mobile/lib/core/theme/app-theme.dart` — Material 3 ThemeData
- `mobile/lib/core/theme/light-theme.dart`
- `mobile/lib/core/theme/dark-theme.dart`
- `mobile/lib/core/database/isar-database-service.dart` — Isar.open() singleton
- `mobile/lib/shared/widgets/empty-state-widget.dart` — reusable empty state

## Implementation Steps

### 1. Create Flutter Project
```bash
# From workspace root: D:\Immortal\Flutter\todo_list_2\
# mobile/ directory already exists (created by workspace setup)
cd mobile
flutter create . --org com.yourname --project-name notes_app \
  --platforms ios,android,web,macos,windows,linux
```

### 2. pubspec.yaml — Add Dependencies
```yaml
# mobile/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  flutter_quill: ^10.8.5
  flutter_quill_extensions: ^10.8.5
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  image_picker: ^1.1.2
  path_provider: ^2.1.3
  uuid: ^4.4.2
  intl: ^0.19.0
  shared_preferences: ^2.3.2   # theme preference

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  isar_generator: ^3.1.0+1
  riverpod_generator: ^2.4.3
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
```

### 3. main.dart
```dart
// mobile/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app-router.dart';
import 'core/theme/app-theme.dart';
import 'core/database/isar-database-service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDatabaseService.initialize();
  runApp(const ProviderScope(child: NotesApp()));
}

class NotesApp extends ConsumerWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Notes',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
```

### 4. go_router — Shell Route với Bottom Nav
```dart
// mobile/lib/core/router/app-router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app-router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/notes',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/notes', builder: (c, s) => const NotesListScreen()),
          GoRoute(path: '/folders', builder: (c, s) => const FoldersScreen()),
          GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
          GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/notes/:id',
        builder: (c, s) => NoteEditorScreen(noteId: s.pathParameters['id']),
      ),
    ],
  );
}
```

### 5. Theme — Material 3
```dart
// mobile/lib/core/theme/app-theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFCC02)),
    fontFamily: 'SF Pro Text', // fallback to system font
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFCC02),
      brightness: Brightness.dark,
    ),
  );
}
```

### 6. Isar Database Service
```dart
// mobile/lib/core/database/isar-database-service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabaseService {
  static late final Isar _isar;
  static Isar get instance => _isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [NoteSchema, FolderSchema, TagSchema],
      directory: dir.path,
    );
  }
}
```

### 7. Run Code Generation
```bash
# From mobile/ directory
dart run build_runner build --delete-conflicting-outputs
```

### 8. Platform Configuration

**iOS** (`mobile/ios/Runner/Info.plist`): Add photo library permission
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Select images for your notes</string>
<key>NSCameraUsageDescription</key>
<string>Take photos for your notes</string>
```

**Android** (`mobile/android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

**Web**: Isar không support Web natively. Dùng `shared_preferences` cho Web fallback hoặc IndexedDB wrapper. → Ghi chú: Web sẽ có limited functionality (no Isar) — dùng in-memory storage cho Web.

### 9. Analysis Options
```yaml
# mobile/analysis_options.yaml
analyzer:
  plugins:
    - custom_lint
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
linter:
  rules:
    - prefer_const_constructors
    - avoid_print
```

## Todo List

- [ ] `cd mobile && flutter create . --project-name notes_app`
- [ ] Update `mobile/pubspec.yaml` với tất cả dependencies
- [ ] Tạo folder structure `mobile/lib/core/` và `mobile/lib/features/`
- [ ] Implement `mobile/lib/main.dart` với ProviderScope
- [ ] Implement `mobile/lib/core/router/app-router.dart` với ShellRoute
- [ ] Implement `mobile/lib/core/theme/app-theme.dart` (light + dark)
- [ ] Implement `mobile/lib/core/database/isar-database-service.dart`
- [ ] Configure iOS `mobile/ios/Runner/Info.plist` permissions
- [ ] Configure Android `mobile/android/app/src/main/AndroidManifest.xml` permissions
- [ ] Run `cd mobile && dart run build_runner build`
- [ ] Test: app chạy được trên iOS simulator + Chrome
- [ ] Verify bottom nav điều hướng đúng 4 tabs

## Success Criteria

- `flutter run` không có lỗi trên iOS + Android + Web
- `dart run build_runner build` thành công
- Bottom nav 4 tabs hoạt động
- Light/Dark theme switch đúng
- Isar initialize thành công (log "Isar opened")

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Isar không support Web | Medium | Web dùng in-memory/localStorage fallback |
| Package version conflicts | Low | Lock versions cụ thể trong pubspec |
| `isar_flutter_libs` build slow | Low | Expect 5-10 min first build |
| go_router ShellRoute navigation | Low | Follow official ShellRoute examples |

## Next Steps

→ Phase 2: Data Models & Isar Database
