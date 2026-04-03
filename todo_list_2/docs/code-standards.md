# Code Standards — todo_list_2 Workspace

**Last updated:** 2026-04-03

## Universal Rules (All Projects)

- YAGNI · KISS · DRY — no over-engineering
- Files ≤ 200 LOC — split into focused modules
- No hardcoded secrets — use env vars or secure storage
- Error handling: always try/catch async operations
- No `print()` in production code — use proper logging

## mobile/ — Flutter/Dart Standards

### File Naming
- Dart files: `snake_case` (Dart ecosystem convention)
- Long descriptive names encouraged: `note-editor-provider.dart` > `provider.dart`

### Code Style
```dart
// ✅ Good — const constructors, named params
const NoteCard({super.key, required this.note, required this.onTap});

// ✅ Good — Riverpod @riverpod annotation
@riverpod
Stream<List<NoteEntity>> notesList(NotesListRef ref) { ... }

// ❌ Bad — avoid late without initialization guarantee
late String title; // only OK in Isar models
```

### Architecture Rules
- Domain layer: pure Dart, no Flutter/Isar imports
- Data layer: Isar models + mappers, no UI logic
- Presentation layer: Riverpod providers + widgets only
- Always run `build_runner` after model changes

### Testing
- Unit tests: domain + data layers (target ≥ 70% coverage)
- Widget tests: critical screens (list, editor)
- Run `flutter analyze` — 0 warnings before commit

## backend/ — NodeJS/TypeScript Standards (Planned)

> Will be filled when backend is scaffolded.

- TypeScript strict mode
- kebab-case file naming
- ESLint + Prettier
- Jest for testing
