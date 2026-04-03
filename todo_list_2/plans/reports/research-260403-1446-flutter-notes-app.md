# Research Report: Flutter Notes App (iPhone Notes / Evernote / GoodNotes)

**Date:** 2026-04-03  
**Project:** todo_list_2 | Flutter Notes App  
**Scope:** Architecture, packages, features, storage, sync

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Target App Feature Analysis](#target-app-feature-analysis)
3. [Flutter Architecture Recommendation](#flutter-architecture-recommendation)
4. [Rich Text Editor Packages](#rich-text-editor-packages)
5. [Local Storage / Database](#local-storage--database)
6. [Cloud Sync & Backend](#cloud-sync--backend)
7. [Advanced Features](#advanced-features)
8. [Recommended Tech Stack](#recommended-tech-stack)
9. [Project Structure](#project-structure)
10. [Risks & Pitfalls](#risks--pitfalls)
11. [Unresolved Questions](#unresolved-questions)

---

## Executive Summary

Xây dựng notes app Flutter giống iPhone Notes/Evernote/GoodNotes là khả thi. Core challenges:
1. **Rich text editor** — đây là thành phần phức tạp nhất, chọn `appflowy_editor` nếu cần block-based (Notion-like), `flutter_quill` nếu cần inline formatting đơn giản hơn.
2. **Local-first storage** — `Isar` hoặc `Drift` (SQLite) cho offline-first, performance tốt.
3. **Sync** — `Supabase` (Firebase alternative, open-source, free tier tốt hơn) hoặc `Firebase Firestore`.
4. **GoodNotes-style handwriting** — cần Flutter Canvas + `perfect_freehand` package, phức tạp riêng.

**Khuyến nghị:** Bắt đầu với MVP = iPhone Notes level (plain/rich text, folders, search, local storage). Sau đó thêm sync và handwriting.

---

## Target App Feature Analysis

### iPhone Notes (iOS)
| Feature | Description |
|---------|-------------|
| Note types | Plain text, rich text, checklists, tables, images |
| Organization | Folders, smart folders, pinned notes |
| Search | Full-text search, highlights matches |
| Formatting | Bold, italic, underline, headers, lists, code blocks |
| Attachments | Images, sketches (built-in canvas), links |
| Sync | iCloud (native, seamless) |
| Share | Share sheet, collaboration links |
| Security | Note locking với Face ID / password |
| Export | No direct export (copy/paste) |

### Evernote
| Feature | Description |
|---------|-------------|
| Note types | Rich text, Web Clips, PDFs, audio recordings |
| Organization | Notebooks, stacks (nested notebooks), tags |
| Search | OCR search in PDFs/images, advanced filters |
| Collaboration | Shared notebooks, real-time co-editing |
| Integrations | Google Drive, Slack, Gmail |
| Export | ENEX, HTML, PDF |

### GoodNotes
| Feature | Description |
|---------|-------------|
| Note types | Handwriting, typed text, images on canvas |
| Organization | Notebooks, folders, smart categories |
| Search | Handwriting recognition + text search |
| Tools | Pen, pencil, highlighter, eraser, lasso |
| Templates | Paper templates (grid, ruled, blank) |
| Export | PDF, images |

### MVP Feature Set (Phase 1 - iPhone Notes Level)
- [x] Create/edit/delete notes
- [x] Rich text formatting (bold, italic, underline, headers, lists)
- [x] Checklists / to-do items
- [x] Folders / notebooks
- [x] Tags
- [x] Full-text search
- [x] Pin notes
- [x] Note colors / labels
- [x] Image insertion
- [x] Dark/Light theme
- [x] Local storage (offline-first)

### Phase 2 (Evernote Level)
- [ ] Cloud sync
- [ ] User authentication
- [ ] PDF attachment support
- [ ] Export (PDF, Markdown)
- [ ] Note sharing via link

### Phase 3 (GoodNotes Level)
- [ ] Handwriting canvas
- [ ] Stylus/pen tool
- [ ] Page templates
- [ ] Handwriting-to-text OCR

---

## Flutter Architecture Recommendation

### State Management: **Riverpod 2.x** ✅
- Tốt nhất cho app phức tạp có nhiều state (notes list, current note, search, folders)
- Type-safe, code generation với `riverpod_generator`
- Dễ test hơn BLoC
- Không cần context để đọc state

```
Riverpod > BLoC > Provider
```

### Architecture Pattern: **Clean Architecture + Feature-First**

```
lib/
├── core/
│   ├── database/        # Isar/Drift setup
│   ├── theme/           # Light/Dark theme
│   └── utils/
├── features/
│   ├── notes/
│   │   ├── data/        # Repository impl, datasources
│   │   ├── domain/      # Entities, repository interfaces, usecases
│   │   └── presentation/ # UI, providers, widgets
│   ├── folders/
│   ├── search/
│   └── settings/
└── main.dart
```

### Navigation: **go_router** (v14+)
- Deep linking support
- Declarative routing
- Shell routes cho bottom nav

---

## Rich Text Editor Packages

### Comparison

| Package | Stars (GitHub) | Pub Score | Block-based | Tables | Collab | Maintenance |
|---------|---------------|-----------|-------------|--------|--------|-------------|
| `appflowy_editor` | ~1.5k | High | ✅ (Notion-like) | ✅ | Possible | Active (AppFlowy team) |
| `flutter_quill` | ~3k | High | ❌ (inline) | Limited | ❌ | Active |
| `super_editor` | ~2k | High | ✅ | ❌ | ❌ | Active (Flutterly team) |

### Recommendation

**For iPhone Notes style** → `flutter_quill`
- Mature, large community
- Supports: bold/italic/underline, headers (H1-H6), bullet/numbered lists, code blocks, blockquote, images, links
- Quill Delta format (JSON) → dễ lưu vào DB
- `pubspec.yaml`: `flutter_quill: ^10.x`

**For Notion/AppFlowy block style** → `appflowy_editor`
- Block-based (drag & drop blocks)
- More powerful nhưng complex hơn
- Maintained by AppFlowy team (production-proven)

**Decision cho project này:** `flutter_quill` cho MVP (closer to iPhone Notes UX)

### flutter_quill Setup
```dart
// pubspec.yaml
dependencies:
  flutter_quill: ^10.0.0
  flutter_quill_extensions: ^10.0.0  # images, video support

// Basic usage
QuillController _controller = QuillController.basic();

Column(children: [
  QuillSimpleToolbar(controller: _controller),
  Expanded(
    child: QuillEditor.basic(
      controller: _controller,
      config: const QuillEditorConfig(placeholder: 'Write your note...'),
    ),
  ),
])

// Save as JSON
final json = jsonEncode(_controller.document.toDelta().toJson());

// Load from JSON
final doc = Document.fromJson(jsonDecode(savedJson));
_controller = QuillController(
  document: doc,
  selection: const TextSelection.collapsed(offset: 0),
);
```

---

## Local Storage / Database

### Comparison

| DB | Type | Performance | Flutter Support | Query Power | Schema Migration |
|----|------|-------------|-----------------|-------------|------------------|
| **Isar** | NoSQL (embedded) | ⭐⭐⭐⭐⭐ | Native Flutter | Good | Auto |
| **Drift** | SQLite ORM | ⭐⭐⭐⭐ | Excellent | Full SQL | Code-gen |
| **sqflite** | SQLite raw | ⭐⭐⭐ | Good | Full SQL | Manual |
| **Hive** | Key-value | ⭐⭐⭐⭐ | Good | Limited | Manual |

### Recommendation: **Isar** (primary) hoặc **Drift** (nếu cần relations phức tạp)

**Isar** - tốt nhất cho notes app:
- Zero-copy reads, rất nhanh
- Native Flutter, ACID compliant
- Full-text search built-in ← quan trọng cho search feature
- Works trên iOS, Android, macOS, Windows, Linux, Web

```dart
// pubspec.yaml
dependencies:
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
dev_dependencies:
  isar_generator: ^3.1.0
  build_runner: ^2.4.0

// Note model
@collection
class Note {
  Id id = Isar.autoIncrement;
  
  @Index(type: IndexType.fullText) // full-text search!
  late String title;
  
  @Index(type: IndexType.fullText)
  late String plainContent; // extracted plain text for search
  
  late String richContent;   // Quill Delta JSON
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isPinned;
  late bool isDeleted; // soft delete
  late String color;
  
  final folder = IsarLink<Folder>();
  final tags = IsarLinks<Tag>();
}

@collection
class Folder {
  Id id = Isar.autoIncrement;
  late String name;
  late String icon;
  final notes = IsarLinks<Note>();
}

@collection  
class Tag {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String name;
  late String color;
}
```

### Full-text Search với Isar
```dart
// Search notes by title + content
Future<List<Note>> searchNotes(String query) async {
  return await isar.notes
    .filter()
    .titleContains(query, caseSensitive: false)
    .or()
    .plainContentContains(query, caseSensitive: false)
    .sortByUpdatedAtDesc()
    .findAll();
}
```

---

## Cloud Sync & Backend

### Options

| Backend | Offline Support | Real-time | Free Tier | Self-host |
|---------|----------------|-----------|-----------|-----------|
| **Supabase** | Via local DB | ✅ | Good (500MB DB) | ✅ |
| **Firebase Firestore** | ✅ Built-in | ✅ | Limited | ❌ |
| **PocketBase** | Via local DB | ✅ | Self-host only | ✅ |
| **Custom API** | Via local DB | Via WebSocket | Your cost | ✅ |

### Recommendation: **Supabase** (nếu cần sync) hoặc **không sync** (local-only MVP)

**Supabase setup:**
```dart
// pubspec.yaml
dependencies:
  supabase_flutter: ^2.x

// Sync strategy: local-first
// 1. All writes go to Isar (immediate)
// 2. Background sync to Supabase
// 3. Conflict resolution: last-write-wins (simple) hoặc created_at comparison
```

### Conflict Resolution Strategy
- **Simple (MVP):** Last-write-wins với `updated_at` timestamp
- **Advanced:** CRDT (Conflict-free Replicated Data Types) - dùng `crdt` package

---

## Advanced Features

### Note Colors / Labels
```dart
const noteColors = [
  Color(0xFFFFFFFF), // White
  Color(0xFFFFF9C4), // Yellow
  Color(0xFFE8F5E9), // Green
  Color(0xFFE3F2FD), // Blue
  Color(0xFFFCE4EC), // Pink
  Color(0xFFEDE7F6), // Purple
];
```

### Image Insertion
- `image_picker`: chọn ảnh từ gallery/camera
- `flutter_quill_extensions`: embed images vào Quill editor
- Store images: local `path_provider` → app documents directory

### Note Lock / Biometric
- `local_auth` package: Face ID, fingerprint
- Store encrypted note IDs in `flutter_secure_storage`

### Export (Phase 2)
- **PDF:** `pdf` package (pub.dev)
- **Markdown:** Parse Quill Delta → Markdown với custom converter
- **HTML:** Quill Delta → HTML

### Handwriting (Phase 3 - GoodNotes)
- `perfect_freehand`: pressure-sensitive stroke rendering
- `flutter_painter_v2`: canvas drawing tools
- Custom `CustomPainter` for pen/pencil/highlighter
- Store as SVG paths hoặc PNG

### Search UI
```dart
// Highlight search matches in note content
TextSpan highlightText(String text, String query) {
  final spans = <TextSpan>[];
  final lower = text.toLowerCase();
  final queryLower = query.toLowerCase();
  int start = 0;
  int index;
  while ((index = lower.indexOf(queryLower, start)) != -1) {
    if (index > start) spans.add(TextSpan(text: text.substring(start, index)));
    spans.add(TextSpan(
      text: text.substring(index, index + query.length),
      style: const TextStyle(backgroundColor: Color(0xFFFFEB3B)),
    ));
    start = index + query.length;
  }
  if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
  return TextSpan(children: spans);
}
```

---

## Recommended Tech Stack

```yaml
# pubspec.yaml (MVP)
dependencies:
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  go_router: ^14.0.0
  
  # Rich text editor
  flutter_quill: ^10.0.0
  flutter_quill_extensions: ^10.0.0
  
  # Local database
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  
  # Image handling
  image_picker: ^1.1.0
  cached_network_image: ^3.3.0
  path_provider: ^2.1.0
  
  # Utils
  uuid: ^4.4.0
  intl: ^0.19.0
  share_plus: ^10.0.0
  
  # Security
  local_auth: ^2.3.0
  flutter_secure_storage: ^9.2.0
  
dev_dependencies:
  build_runner: ^2.4.0
  isar_generator: ^3.1.0
  riverpod_generator: ^2.4.0
```

---

## Project Structure

```
lib/
├── core/
│   ├── database/
│   │   ├── isar-database-service.dart
│   │   └── models/
│   │       ├── note-model.dart
│   │       ├── folder-model.dart
│   │       └── tag-model.dart
│   ├── router/
│   │   └── app-router.dart
│   └── theme/
│       ├── app-theme.dart
│       ├── light-theme.dart
│       └── dark-theme.dart
├── features/
│   ├── notes/
│   │   ├── data/
│   │   │   ├── note-repository-impl.dart
│   │   │   └── note-local-datasource.dart
│   │   ├── domain/
│   │   │   ├── note-entity.dart
│   │   │   ├── note-repository.dart
│   │   │   └── usecases/
│   │   │       ├── create-note-usecase.dart
│   │   │       ├── update-note-usecase.dart
│   │   │       ├── delete-note-usecase.dart
│   │   │       └── search-notes-usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── notes-provider.dart
│   │       │   └── note-editor-provider.dart
│   │       ├── screens/
│   │       │   ├── notes-list-screen.dart
│   │       │   └── note-editor-screen.dart
│   │       └── widgets/
│   │           ├── note-card-widget.dart
│   │           ├── note-grid-widget.dart
│   │           └── quill-toolbar-widget.dart
│   ├── folders/
│   ├── search/
│   └── settings/
└── main.dart
```

---

## Risks & Pitfalls

| Risk | Impact | Mitigation |
|------|--------|-----------|
| `flutter_quill` delta serialization lớn | Medium | Store plain text separately for search |
| Isar v3 deprecated (v4 beta) | Low | Stick với v3 stable, plan migrate |
| Handwriting performance trên low-end devices | High | Phase 3 only, test early |
| iCloud sync trên iOS | High | Dùng Supabase thay vì iCloud native |
| Rich text → search index | Medium | Extract plain text khi save |
| Image storage path thay đổi sau update | Medium | Dùng relative paths + documents dir |

---

## Unresolved Questions

1. **Target platform**: iOS only, Android only, hay cross-platform (iOS + Android + Web)?
2. **Cloud sync có cần không?** Nếu không → bỏ Supabase, đơn giản hóa đáng kể.
3. **GoodNotes handwriting**: Có cần canvas drawing trong MVP không? Rất phức tạp.
4. **Authentication**: Có cần login/user accounts không?
5. **Existing codebase**: `todo_list_2` folder có code Flutter gì rồi? Cần tái sử dụng hay fresh start?
6. **Design language**: Material 3 (Android-first) hay Cupertino (iOS-feel) hay custom?
7. **Free/paid tier**: App store distribution? IAP for premium features?

---

*Research conducted: 2026-04-03 | Sources: Web search, pub.dev, GitHub*
