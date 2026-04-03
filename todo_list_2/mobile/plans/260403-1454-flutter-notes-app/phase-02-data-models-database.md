# Phase 2: Data Models & Isar Database

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** Pending | **Priority:** P1 | **Est:** 10h
**Blocked by:** Phase 1 (Project Setup)

## Overview

Định nghĩa tất cả data models (Note, Folder, Tag) với Isar `@collection` annotations, implement repository layer, và data access layer theo Clean Architecture.

## Key Insights

- Note lưu `richContent` (Quill Delta JSON) + `plainContent` (plain text cho search)
- `plainContent` được extract tự động từ Delta khi save → không search trong JSON
- Soft delete (`isDeleted = true`) thay vì hard delete → cho phép "Recently Deleted" feature sau
- Isar Links: Note ↔ Folder (1:many), Note ↔ Tag (many:many)
- Repository pattern: domain layer chỉ biết abstract interface, không biết Isar

## Requirements

### Functional
- [ ] Note model với: title, richContent, plainContent, createdAt, updatedAt, isPinned, isDeleted, color, folder link, tag links
- [ ] Folder model với: name, icon, color, parent folder (nested folders support)
- [ ] Tag model với: name, color (unique name)
- [ ] Repository interfaces trong domain layer
- [ ] Repository implementations trong data layer (Isar)
- [ ] Riverpod providers cho repositories

### Non-functional
- Tất cả Isar models có `@Index` trên search fields
- Repository methods đều async
- Error handling với try/catch, return `Result<T>` hoặc throw custom exceptions

## Architecture

```
lib/
├── core/
│   └── database/
│       ├── isar-database-service.dart      # (Phase 1)
│       └── models/
│           ├── note-isar-model.dart        # @collection Note
│           ├── folder-isar-model.dart      # @collection Folder
│           └── tag-isar-model.dart         # @collection Tag
├── features/
│   ├── notes/
│   │   ├── domain/
│   │   │   ├── note-entity.dart            # Pure Dart entity
│   │   │   ├── note-repository.dart        # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── create-note-usecase.dart
│   │   │       ├── update-note-usecase.dart
│   │   │       ├── delete-note-usecase.dart
│   │   │       ├── get-notes-usecase.dart
│   │   │       └── search-notes-usecase.dart
│   │   └── data/
│   │       ├── note-repository-impl.dart   # Isar impl
│   │       ├── note-local-datasource.dart  # Raw Isar queries
│   │       └── note-mapper.dart            # Isar ↔ Entity
│   ├── folders/
│   │   ├── domain/
│   │   │   ├── folder-entity.dart
│   │   │   └── folder-repository.dart
│   │   └── data/
│   │       ├── folder-repository-impl.dart
│   │       └── folder-mapper.dart
│   └── tags/
│       ├── domain/
│       │   ├── tag-entity.dart
│       │   └── tag-repository.dart
│       └── data/
│           ├── tag-repository-impl.dart
│           └── tag-mapper.dart
```

## Related Code Files

### Create
- `lib/core/database/models/note-isar-model.dart`
- `lib/core/database/models/folder-isar-model.dart`
- `lib/core/database/models/tag-isar-model.dart`
- `lib/features/notes/domain/note-entity.dart`
- `lib/features/notes/domain/note-repository.dart`
- `lib/features/notes/data/note-repository-impl.dart`
- `lib/features/notes/data/note-local-datasource.dart`
- `lib/features/notes/data/note-mapper.dart`
- `lib/features/folders/domain/folder-entity.dart`
- `lib/features/folders/domain/folder-repository.dart`
- `lib/features/folders/data/folder-repository-impl.dart`
- `lib/features/tags/domain/tag-entity.dart`
- `lib/features/tags/domain/tag-repository.dart`
- `lib/features/tags/data/tag-repository-impl.dart`

## Implementation Steps

### 1. Note Isar Model
```dart
// lib/core/database/models/note-isar-model.dart
import 'package:isar/isar.dart';
part 'note-isar-model.g.dart';

@collection
class NoteIsarModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String uuid; // cross-platform sync ID (UUID v4)

  @Index(type: IndexType.fullText, caseSensitive: false)
  late String title;

  @Index(type: IndexType.fullText, caseSensitive: false)
  late String plainContent; // extracted plain text — for search only

  late String richContent;  // Quill Delta JSON — for display

  @Index(type: IndexType.value)
  late DateTime createdAt;

  @Index(type: IndexType.value)
  late DateTime updatedAt;

  late bool isPinned;
  late bool isDeleted; // soft delete
  late String color;   // hex color string e.g. "#FFFFFF"

  // Relations
  final folder = IsarLink<FolderIsarModel>();
  final tags = IsarLinks<TagIsarModel>();
}
```

### 2. Folder Isar Model
```dart
// lib/core/database/models/folder-isar-model.dart
import 'package:isar/isar.dart';
part 'folder-isar-model.g.dart';

@collection
class FolderIsarModel {
  Id id = Isar.autoIncrement;
  late String uuid;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  late String icon;   // emoji or icon name e.g. "📁"
  late String color;  // hex
  late DateTime createdAt;

  // Self-referential for nested folders (optional MVP feature)
  final parentFolder = IsarLink<FolderIsarModel>();
  final notes = IsarLinks<NoteIsarModel>();
}
```

### 3. Tag Isar Model
```dart
// lib/core/database/models/tag-isar-model.dart
import 'package:isar/isar.dart';
part 'tag-isar-model.g.dart';

@collection
class TagIsarModel {
  Id id = Isar.autoIncrement;
  late String uuid;

  @Index(unique: true, caseSensitive: false)
  late String name;

  late String color; // hex
}
```

### 4. Note Entity (Domain)
```dart
// lib/features/notes/domain/note-entity.dart
class NoteEntity {
  final String id;       // UUID
  final String title;
  final String plainContent;
  final String richContent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isDeleted;
  final String color;
  final String? folderId;
  final List<String> tagIds;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.plainContent,
    required this.richContent,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isDeleted,
    required this.color,
    this.folderId,
    this.tagIds = const [],
  });

  NoteEntity copyWith({
    String? title,
    String? plainContent,
    String? richContent,
    bool? isPinned,
    bool? isDeleted,
    String? color,
    String? folderId,
    List<String>? tagIds,
  }) {
    return NoteEntity(
      id: id,
      title: title ?? this.title,
      plainContent: plainContent ?? this.plainContent,
      richContent: richContent ?? this.richContent,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      color: color ?? this.color,
      folderId: folderId ?? this.folderId,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}
```

### 5. Note Repository Interface
```dart
// lib/features/notes/domain/note-repository.dart
import 'note-entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getAllNotes({String? folderId, bool includeDeleted = false});
  Future<NoteEntity?> getNoteById(String id);
  Future<NoteEntity> createNote(NoteEntity note);
  Future<NoteEntity> updateNote(NoteEntity note);
  Future<void> deleteNote(String id); // soft delete
  Future<void> permanentlyDeleteNote(String id);
  Future<List<NoteEntity>> searchNotes(String query);
  Stream<List<NoteEntity>> watchNotes({String? folderId});
}
```

### 6. Note Local Datasource (Isar)
```dart
// lib/features/notes/data/note-local-datasource.dart
import 'package:isar/isar.dart';
import '../../../core/database/isar-database-service.dart';
import '../../../core/database/models/note-isar-model.dart';

class NoteLocalDatasource {
  Isar get _db => IsarDatabaseService.instance;

  Future<List<NoteIsarModel>> getAll({int? folderId}) async {
    var query = _db.noteIsarModels
        .filter()
        .isDeletedEqualTo(false);
    if (folderId != null) {
      query = query.folder((f) => f.idEqualTo(folderId));
    }
    return query.sortByIsPinnedDesc().sortByUpdatedAtDesc().findAll();
  }

  Future<List<NoteIsarModel>> search(String q) async {
    return _db.noteIsarModels
        .filter()
        .isDeletedEqualTo(false)
        .and()
        .group((g) => g
          .titleContains(q, caseSensitive: false)
          .or()
          .plainContentContains(q, caseSensitive: false))
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Stream<List<NoteIsarModel>> watchAll() {
    return _db.noteIsarModels
        .filter()
        .isDeletedEqualTo(false)
        .sortByIsPinnedDesc()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<void> save(NoteIsarModel model) async {
    await _db.writeTxn(() => _db.noteIsarModels.put(model));
  }

  Future<void> softDelete(int id) async {
    await _db.writeTxn(() async {
      final note = await _db.noteIsarModels.get(id);
      if (note != null) {
        note.isDeleted = true;
        note.updatedAt = DateTime.now();
        await _db.noteIsarModels.put(note);
      }
    });
  }

  Future<void> hardDelete(int id) async {
    await _db.writeTxn(() => _db.noteIsarModels.delete(id));
  }
}
```

### 7. Note Mapper
```dart
// lib/features/notes/data/note-mapper.dart
import '../domain/note-entity.dart';
import '../../../core/database/models/note-isar-model.dart';

class NoteMapper {
  static NoteEntity toEntity(NoteIsarModel model) {
    return NoteEntity(
      id: model.uuid,
      title: model.title,
      plainContent: model.plainContent,
      richContent: model.richContent,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isPinned: model.isPinned,
      isDeleted: model.isDeleted,
      color: model.color,
      folderId: model.folder.value?.uuid,
      tagIds: model.tags.map((t) => t.uuid).toList(),
    );
  }

  static NoteIsarModel toModel(NoteEntity entity, {int? existingId}) {
    final model = NoteIsarModel()
      ..id = existingId ?? Isar.autoIncrement
      ..uuid = entity.id
      ..title = entity.title
      ..plainContent = entity.plainContent
      ..richContent = entity.richContent
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..isPinned = entity.isPinned
      ..isDeleted = entity.isDeleted
      ..color = entity.color;
    return model;
  }
}
```

### 8. Riverpod Providers
```dart
// lib/features/notes/data/note-repository-impl.dart (excerpt)
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'note-repository-impl.g.dart';

@riverpod
NoteLocalDatasource noteDatasource(NoteDatasourceRef ref) {
  return NoteLocalDatasource();
}

@riverpod
NoteRepository noteRepository(NoteRepositoryRef ref) {
  return NoteRepositoryImpl(ref.watch(noteDatasourceProvider));
}
```

### 9. Update IsarDatabaseService với Schemas
```dart
// Update lib/core/database/isar-database-service.dart
_isar = await Isar.open(
  [NoteIsarModelSchema, FolderIsarModelSchema, TagIsarModelSchema],
  directory: dir.path,
);
```

### 10. Run Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Todo List

- [ ] Tạo `note-isar-model.dart` với đầy đủ fields + indexes
- [ ] Tạo `folder-isar-model.dart`
- [ ] Tạo `tag-isar-model.dart`
- [ ] Run `build_runner` → generate `.g.dart` files
- [ ] Tạo `note-entity.dart` với `copyWith`
- [ ] Tạo `folder-entity.dart`
- [ ] Tạo `tag-entity.dart`
- [ ] Tạo abstract `note-repository.dart`
- [ ] Tạo abstract `folder-repository.dart`
- [ ] Tạo abstract `tag-repository.dart`
- [ ] Implement `note-local-datasource.dart`
- [ ] Implement `note-mapper.dart`
- [ ] Implement `note-repository-impl.dart`
- [ ] Implement `folder-repository-impl.dart`
- [ ] Implement `tag-repository-impl.dart`
- [ ] Tạo Riverpod providers cho tất cả repositories
- [ ] Verify: Isar open thành công với tất cả 3 schemas
- [ ] Test: write/read 1 note manually trong main.dart

## Success Criteria

- `build_runner` generate tất cả `.g.dart` files không lỗi
- Có thể create + read Note qua repository trong test
- Isar indexes được tạo cho fullText search trên `title` và `plainContent`
- Stream watch emit khi có note thay đổi

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| IsarLinks load lazy (need `loadLinks()`) | Medium | Luôn gọi `await model.folder.load()` trước khi map |
| UUID conflict (duplicate notes khi sync sau) | Low | UUID v4 → collision probability negligible |
| Isar schema migration khi add field | Medium | Test schema changes với `Isar.open(schemas, inspector: true)` |

## Next Steps

→ Phase 3: Notes CRUD + Rich Text Editor
