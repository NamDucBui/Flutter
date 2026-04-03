# Phase 3: Notes CRUD + Rich Text Editor

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** ✅ Complete | **Priority:** P1 | **Est:** 20h
**Blocked by:** Phase 2 (Data Models)

## Overview

Implement toàn bộ Notes CRUD UI: list screen, editor screen với `flutter_quill`, auto-save, note colors, pin/unpin, image insertion. Đây là core feature của app.

## Key Insights

- `flutter_quill` delta → JSON string → lưu vào `richContent`. Extract plain text → `plainContent` cho search
- Auto-save dùng debounce (500ms) khi user ngừng gõ — không cần "Save" button
- Note title = first line của document nếu user không nhập title riêng
- Image files lưu vào `getApplicationDocumentsDirectory()/images/` với UUID filename
- `QuillController.document.toPlainText()` để extract plain text

## Requirements

### Functional
- [ ] Notes list screen: grid/list view toggle, pinned notes section
- [ ] Note card: preview text, date, color, pin indicator
- [ ] FAB để tạo note mới
- [ ] Note editor: QuillEditor + QuillSimpleToolbar
- [ ] Auto-save với debounce 500ms
- [ ] Note title auto-extracted từ first line
- [ ] Toolbar: bold, italic, underline, strike, H1/H2, bullet list, numbered list, checklist, image, link, color
- [ ] Note color picker (6 colors)
- [ ] Pin/unpin từ editor + long press trên card
- [ ] Swipe to delete (soft delete) trên note card
- [ ] Undo/Redo trong editor
- [ ] Note info: word count, character count, last modified

### Non-functional
- Auto-save không block UI thread
- Image compression trước khi lưu (max 1MB)
- Tất cả widgets ≤ 200 LOC

## Architecture

```
lib/features/notes/
├── domain/
│   └── usecases/
│       ├── create-note-usecase.dart
│       ├── update-note-usecase.dart
│       └── delete-note-usecase.dart
├── presentation/
│   ├── providers/
│   │   ├── notes-list-provider.dart      # watch all notes stream
│   │   ├── note-editor-provider.dart     # current note state + auto-save
│   │   └── note-color-provider.dart      # selected color state
│   ├── screens/
│   │   ├── notes-list-screen.dart        # main list/grid
│   │   └── note-editor-screen.dart       # editor + toolbar
│   └── widgets/
│       ├── note-card-widget.dart         # list item card
│       ├── note-grid-card-widget.dart    # grid item card
│       ├── note-color-picker-widget.dart # bottom sheet color picker
│       ├── notes-app-bar-widget.dart     # app bar with view toggle
│       └── quill-image-handler.dart      # image embed + pick
```

## Implementation Steps

### 1. Notes List Provider
```dart
// lib/features/notes/presentation/providers/notes-list-provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/note-entity.dart';
import '../../data/note-repository-impl.dart';
part 'notes-list-provider.g.dart';

@riverpod
Stream<List<NoteEntity>> notesList(NotesListRef ref, {String? folderId}) {
  return ref.watch(noteRepositoryProvider).watchNotes(folderId: folderId);
}

// Separate pinned and regular notes
@riverpod
AsyncValue<(List<NoteEntity>, List<NoteEntity>)> pinnedAndNotes(
  PinnedAndNotesRef ref, {String? folderId}
) {
  return ref.watch(notesListProvider(folderId: folderId)).whenData((notes) {
    final pinned = notes.where((n) => n.isPinned).toList();
    final regular = notes.where((n) => !n.isPinned).toList();
    return (pinned, regular);
  });
}
```

### 2. Note Editor Provider (Auto-save)
```dart
// lib/features/notes/presentation/providers/note-editor-provider.dart
import 'dart:async';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'note-editor-provider.g.dart';

@riverpod
class NoteEditor extends _$NoteEditor {
  Timer? _debounce;
  late QuillController _controller;

  QuillController get controller => _controller;

  @override
  AsyncValue<NoteEntity?> build(String? noteId) {
    _initController();
    if (noteId != null) _loadNote(noteId);
    return const AsyncValue.loading();
  }

  void _initController() {
    _controller = QuillController.basic();
    _controller.document.changes.listen((_) => _scheduleSave());
  }

  Future<void> _loadNote(String id) async {
    final note = await ref.read(noteRepositoryProvider).getNoteById(id);
    if (note != null) {
      final doc = note.richContent.isEmpty
          ? Document()
          : Document.fromJson(jsonDecode(note.richContent));
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      _controller.document.changes.listen((_) => _scheduleSave());
      state = AsyncValue.data(note);
    }
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _save);
  }

  Future<void> _save() async {
    final plainText = _controller.document.toPlainText().trim();
    final lines = plainText.split('\n');
    final title = lines.isNotEmpty ? lines.first.trim() : 'Untitled';
    final richJson = jsonEncode(_controller.document.toDelta().toJson());

    final current = state.valueOrNull;
    if (current == null) {
      // Create new note
      final newNote = NoteEntity(
        id: const Uuid().v4(),
        title: title,
        plainContent: plainText,
        richContent: richJson,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isDeleted: false,
        color: '#FFFFFF',
      );
      final saved = await ref.read(noteRepositoryProvider).createNote(newNote);
      state = AsyncValue.data(saved);
    } else {
      final updated = current.copyWith(
        title: title,
        plainContent: plainText,
        richContent: richJson,
      );
      await ref.read(noteRepositoryProvider).updateNote(updated);
      state = AsyncValue.data(updated);
    }
  }

  Future<void> togglePin() async {
    final note = state.valueOrNull;
    if (note == null) return;
    final updated = note.copyWith(isPinned: !note.isPinned);
    await ref.read(noteRepositoryProvider).updateNote(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> setColor(String color) async {
    final note = state.valueOrNull;
    if (note == null) return;
    final updated = note.copyWith(color: color);
    await ref.read(noteRepositoryProvider).updateNote(updated);
    state = AsyncValue.data(updated);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
```

### 3. Notes List Screen
```dart
// lib/features/notes/presentation/screens/notes-list-screen.dart
class NotesListScreen extends ConsumerStatefulWidget {
  final String? folderId;
  const NotesListScreen({super.key, this.folderId});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(pinnedAndNotesProvider(folderId: widget.folderId));

    return Scaffold(
      appBar: NotesAppBarWidget(
        title: 'Notes',
        isGridView: _isGridView,
        onToggleView: () => setState(() => _isGridView = !_isGridView),
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final (pinned, notes) = data;
          if (pinned.isEmpty && notes.isEmpty) return const EmptyStateWidget();
          return _NotesSections(
            pinned: pinned,
            notes: notes,
            isGrid: _isGridView,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/notes/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}
```

### 4. Note Editor Screen
```dart
// lib/features/notes/presentation/screens/note-editor-screen.dart
class NoteEditorScreen extends ConsumerWidget {
  final String? noteId;
  const NoteEditorScreen({super.key, this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorAsync = ref.watch(noteEditorProvider(noteId));
    final editor = ref.read(noteEditorProvider(noteId).notifier);

    return Scaffold(
      backgroundColor: _getNoteColor(editorAsync.valueOrNull?.color),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(editorAsync.valueOrNull?.isPinned == true
                ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: editor.togglePin,
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showColorPicker(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showNoteOptions(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          QuillSimpleToolbar(
            controller: editor.controller,
            config: QuillSimpleToolbarConfig(
              showFontFamily: false,
              showFontSize: false,
              showInlineCode: true,
              showCodeBlock: false,
              showQuote: true,
              showSubscript: false,
              showSuperscript: false,
              embedButtons: [
                QuillToolbarImageButton.new, // image insert
              ],
            ),
          ),
          const Divider(height: 1),
          // Editor
          Expanded(
            child: QuillEditor.basic(
              controller: editor.controller,
              config: const QuillEditorConfig(
                padding: EdgeInsets.all(16),
                placeholder: 'Start writing...',
                autoFocus: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNoteColor(String? hex) {
    if (hex == null) return Colors.white;
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
```

### 5. Note Card Widget
```dart
// lib/features/notes/presentation/widgets/note-card-widget.dart
class NoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCardWidget({
    super.key, required this.note,
    required this.onTap, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        color: note.color == '#FFFFFF'
            ? null
            : Color(int.parse(note.color.replaceFirst('#', '0xFF'))),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(note.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isPinned)
                      const Icon(Icons.push_pin, size: 14),
                  ],
                ),
                if (note.plainContent.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(note.plainContent,
                    maxLines: 3, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  _formatDate(note.updatedAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) return DateFormat.jm().format(dt);
    if (now.difference(dt).inDays < 7) return DateFormat.E().format(dt);
    return DateFormat.MMMd().format(dt);
  }
}
```

### 6. Note Color Picker Widget
```dart
// lib/features/notes/presentation/widgets/note-color-picker-widget.dart
const _noteColors = {
  '#FFFFFF': 'White',
  '#FFF9C4': 'Yellow',
  '#E8F5E9': 'Green',
  '#E3F2FD': 'Blue',
  '#FCE4EC': 'Pink',
  '#EDE7F6': 'Purple',
};

class NoteColorPickerWidget extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const NoteColorPickerWidget({
    super.key, required this.selectedColor, required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _noteColors.entries.map((e) {
          final isSelected = e.key == selectedColor;
          return GestureDetector(
            onTap: () => onColorSelected(e.key),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Color(int.parse(e.key.replaceFirst('#', '0xFF'))),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### 7. Image Embedding
```dart
// lib/features/notes/presentation/widgets/quill-image-handler.dart
class QuillImageHandler {
  static Future<String?> pickAndSaveImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920, maxHeight: 1920, imageQuality: 80,
    );
    if (file == null) return null;

    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${docsDir.path}/images');
    await imagesDir.create(recursive: true);

    final ext = file.path.split('.').last;
    final filename = '${const Uuid().v4()}.$ext';
    final saved = await File(file.path).copy('${imagesDir.path}/$filename');
    return saved.path;
  }
}
```

## Todo List

- [ ] Implement `notes-list-provider.dart` (stream + pinned/regular split)
- [ ] Implement `note-editor-provider.dart` với auto-save debounce
- [ ] Implement `notes-list-screen.dart` với grid/list toggle
- [ ] Implement `note-editor-screen.dart` với QuillEditor + toolbar
- [ ] Implement `note-card-widget.dart` với Dismissible
- [ ] Implement `note-grid-card-widget.dart` (grid variant)
- [ ] Implement `note-color-picker-widget.dart`
- [ ] Implement `notes-app-bar-widget.dart`
- [ ] Implement `quill-image-handler.dart`
- [ ] Connect routes: `/notes/new` → editor (no ID), `/notes/:id` → editor (with ID)
- [ ] Test: tạo note → auto-save → reload app → note vẫn còn
- [ ] Test: swipe delete → note biến mất khỏi list
- [ ] Test: toggle pin → note lên đầu danh sách
- [ ] Test: chọn color → background card thay đổi
- [ ] Test: chèn ảnh → hiển thị trong editor

## Success Criteria

- Tạo note mới, gõ text → auto-save sau 500ms (verify bằng hot restart)
- Pinned notes luôn ở đầu list
- Color picker thay đổi màu card và editor background
- Swipe to delete với undo snackbar
- Image chèn vào editor và persist sau reload
- Grid/list view toggle mượt

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Auto-save race condition | Medium | Debounce + cancel timer on dispose |
| QuillController dispose crash | Medium | Dispose trong provider.dispose() |
| Image path invalid sau app update | Medium | Store relative path, reconstruct absolute |
| Quill delta size quá lớn | Low | Monitor, compress empty delta nodes |

## Next Steps

→ Phase 4: Folders, Tags & Organization
