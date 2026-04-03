# Codebase Summary — todo_list_2 Workspace

**Last updated:** 2026-04-03 | **Version:** v0.1.0-MVP

## mobile/ — Flutter Notes App

### Overview
Local-first notes app with rich text editing, folder organization, tagging, full-text search, and persistent settings. Targets iOS, Android, Web, macOS, Windows, Linux.

### Architecture
Implements **Clean Architecture** (Domain → Data → Presentation):

```
mobile/lib/
├── core/
│   ├── database/              # ObjectBox singleton, migration logic
│   ├── router/                # go_router ShellRoute, named routes
│   └── theme/                 # Material 3 light/dark themes
├── features/
│   ├── notes/
│   │   ├── domain/            # Note entity, NoteRepository interface, usecases
│   │   ├── data/              # ObjectBox impl, entities, mappers
│   │   └── presentation/      # Riverpod providers, screens, widgets
│   ├── folders/
│   │   ├── domain/            # Folder entity, repository interface
│   │   ├── data/              # ObjectBox impl
│   │   └── presentation/      # Providers, drawer, widgets
│   ├── tags/
│   │   ├── domain/            # Tag entity, repository
│   │   ├── data/              # ObjectBox impl
│   │   └── presentation/      # Tag assignment/filtering widgets
│   ├── search/
│   │   ├── domain/            # Search usecase
│   │   ├── data/              # ObjectBox full-text search
│   │   └── presentation/      # Search screen, providers, highlights
│   └── settings/
│       ├── domain/            # Settings entity, repository
│       ├── data/              # SharedPreferences impl
│       └── presentation/      # Settings screen, theme/sort providers
├── shared/
│   ├── widgets/               # AppScaffold, NoteCard, QuillToolbar wrapper
│   └── utils/                 # formatters, validators, constants
└── main.dart                  # app entry point, ProviderScope wrapper
```

### Key Technology Stack

| Component | Package | Version | Purpose |
|-----------|---------|---------|---------|
| **State Management** | flutter_riverpod + riverpod_annotation | 3.0.0 + 4.0.0 | Reactive, testable providers w/ codegen |
| **Navigation** | go_router | 14.2.0 | Declarative routing, deep linking support |
| **Local Storage** | objectbox + objectbox_flutter_libs | 5.3.0 + any | Embedded NoSQL, full-text search, migrations |
| **Rich Text** | flutter_quill + flutter_quill_extensions | 11.5.0 + 11.0.0 | Delta JSON format, toolbar, embeds |
| **Image Picker** | image_picker | 1.1.2 | Camera/gallery image selection |
| **Settings Persistence** | shared_preferences | 2.3.2 | Key-value storage (theme, sort, search history) |
| **Utilities** | uuid, path_provider, intl | 4.4.2, 2.1.3, any | UUID generation, app directories, i18n ready |
| **Testing** | flutter_test | sdk | Widget & unit tests |
| **Code Generation** | build_runner, objectbox_generator | 2.4.11, any | Model/provider generation |

### Data Models (ObjectBox)

**Note**
- `id` (int, primary key)
- `title` (string)
- `content` (string, Delta JSON)
- `folder` (relation to Folder)
- `tags` (many-to-many)
- `color` (int, material color hash)
- `isPinned` (bool)
- `createdAt`, `updatedAt` (datetime)
- Full-text search enabled on `title`, `content`

**Folder**
- `id` (int, primary key)
- `name` (string)
- `colorHex` (string)
- `notes` (reverse relation)
- `createdAt`, `updatedAt` (datetime)

**Tag**
- `id` (int, primary key)
- `name` (string)
- `colorHex` (string)
- `notes` (many-to-many)
- `createdAt`, `updatedAt` (datetime)

### State Management (Riverpod)

**Note Providers**
- `notesList` — Stream<List<Note>> w/ sorting/filtering
- `notesById` — Cache by ID
- `createNote`, `updateNote`, `deleteNote` — mutations
- `noteSearch` — filtered by query + tags + folder

**Folder Providers**
- `foldersList` — read-only list
- `createFolder`, `updateFolder`, `deleteFolder`

**Tag Providers**
- `tagsList` — read-only list
- `createTag`, `deleteTag`

**Settings Providers**
- `themeMode` — light/dark (persisted)
- `sortBy` — name/date/color (persisted)
- `recentSearches` — list (persisted)

### UI/UX Features

**Notes Screen**
- Grid/List toggle (persisted)
- Color-coded cards
- Pin indicator
- Tap → editor, long-press → quick actions

**Rich Text Editor**
- Quill toolbar (bold, italic, link, list, etc.)
- Auto-save to ObjectBox (debounced 1s)
- Responsive layout (mobile/tablet/desktop)
- Color picker for note customization

**Folders Drawer**
- Create/rename/delete folders
- Drag-to-reorder (future)
- Folder-filtered notes list

**Tags System**
- Inline tag assignment in editor
- Multi-tag filtering with chips
- Auto-complete suggestions

**Full-Text Search**
- Debounced query (500ms)
- Highlight matching text
- Recent searches carousel
- Filter by folder + tags

**Settings Screen**
- Theme toggle (Material 3 light/dark)
- Sort order (name, date, color)
- App info/version

**Responsive Layout**
- Mobile: single column, bottom nav
- Tablet: split-view (drawer + list + editor)
- Desktop: full window with resizable panels

### Testing Coverage

10+ tests covering:
- Note CRUD operations (create, read, update, delete)
- Folder operations (create, rename, delete)
- Tag assignment/filtering
- Full-text search (query, highlights)
- Settings persistence
- Widget rendering (NoteCard, editor preview)

**Target:** ≥70% coverage; run `flutter test` from `mobile/`

### Build & Development Commands

```bash
cd mobile/

# Install dependencies
flutter pub get

# Code generation (required after model/provider changes)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build release APK/IPA/Web
flutter build apk
flutter build ios
flutter build web
```

### Known Limitations (MVP)

- **No cloud sync** — purely local storage (planned Phase 2)
- **No authentication** — app is single-user, device-only (planned Phase 2)
- **No handwriting** — text-only input (deferred)
- **No export** — save as PDF/Markdown (deferred)
- **No collaboration** — single user per device
- **No offline detection UI** — always assumes offline-first

### Next Steps (Post-MVP)

1. **Cloud Backend** — NodeJS API for sync (see `backend/` Planned)
2. **Authentication** — Firebase Auth or Supabase JWT
3. **Conflict Resolution** — OT/CRDT for collaborative editing
4. **Handwriting** — Flutter ink input plugin
5. **Export** — PDF generation, Markdown export
6. **Desktop Optimization** — keyboard shortcuts, drag-drop
7. **i18n** — multi-language support (intl package ready)

---

## backend/ — NodeJS API (Planned)

Not yet scaffolded. Planned for Phase 2 (cloud sync).

**Expected Stack:** TypeScript + Fastify/NestJS + Supabase PostgreSQL + JWT Auth

See `project-overview-pdr.md` for details.
