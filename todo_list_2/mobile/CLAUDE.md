# CLAUDE.md — mobile/

## Project Context

**Type:** Flutter mobile/desktop/web app
**Workspace root:** `D:\Immortal\Flutter\todo_list_2\`
**This project:** `D:\Immortal\Flutter\todo_list_2\mobile\`

Inherits all rules from workspace root `CLAUDE.md`. Rules below are Flutter-specific overrides.

## Flutter-Specific Rules

- Flutter SDK ≥ 3.19, Dart ≥ 3.3
- State management: Riverpod 2.x with code generation (`riverpod_generator`)
- Navigation: go_router v14+
- Database: Isar v3 (local-first, offline-first)
- All Dart source files use `snake_case` (Dart/Flutter convention)
- Run `dart run build_runner build --delete-conflicting-outputs` after any model/provider changes
- Keep files ≤ 200 LOC — split into focused modules

## Project Plans

Plans are stored at workspace level: `../plans/`
Active plan: `../plans/260403-1454-flutter-notes-app/`

## Commands

```bash
# Run from mobile/ directory
flutter pub get
flutter run
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
```

## Architecture

```
mobile/
├── lib/
│   ├── core/          # database, router, theme
│   ├── features/      # notes, folders, tags, search, settings
│   ├── shared/        # reusable widgets, utils
│   └── main.dart
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```
