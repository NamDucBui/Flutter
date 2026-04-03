# Phase 4: Folders, Tags & Organization

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** Pending | **Priority:** P1 | **Est:** 16h
**Blocked by:** Phase 3 (Notes CRUD)

## Overview

Implement folder management (create/rename/delete), tag system (create/assign/filter), move notes giữa folders, và sidebar/drawer navigation theo kiểu iPhone Notes.

## Key Insights

- Folders hiển thị trong drawer (mobile) hoặc sidebar (tablet/desktop)
- Tag filter: chọn tag → filter notes list theo tag đó
- "All Notes" = default view không filter folder
- "Recently Deleted" = pseudo-folder filter `isDeleted == true`
- Note count per folder hiển thị bên cạnh folder name
- Drag-to-move note vào folder (Phase 2 feature, không trong MVP) → chỉ dùng bottom sheet "Move to folder"

## Requirements

### Functional
- [ ] Folders screen: list tất cả folders với note count
- [ ] Create folder với name + icon (emoji picker hoặc preset icons)
- [ ] Rename folder (long press → context menu)
- [ ] Delete folder (notes trong folder → move to "All Notes")
- [ ] Tags: create tag với name + color
- [ ] Assign tags cho note từ editor (bottom sheet)
- [ ] Filter notes theo folder (tap folder → notes list filtered)
- [ ] Filter notes theo tag (tap tag → notes list filtered)
- [ ] "Recently Deleted" folder (soft-deleted notes, auto-purge sau 30 days)
- [ ] Note detail: hiển thị folder badge + tags chips

### Non-functional
- Folder list sorted alphabetically
- Tags sorted by usage frequency
- Empty folder shows placeholder

## Architecture

```
lib/features/
├── folders/
│   ├── domain/
│   │   ├── folder-entity.dart           # (Phase 2)
│   │   ├── folder-repository.dart       # (Phase 2)
│   │   └── usecases/
│   │       ├── create-folder-usecase.dart
│   │       ├── rename-folder-usecase.dart
│   │       └── delete-folder-usecase.dart
│   ├── data/
│   │   ├── folder-repository-impl.dart  # (Phase 2)
│   │   └── folder-datasource.dart
│   └── presentation/
│       ├── providers/
│       │   └── folders-provider.dart
│       ├── screens/
│       │   └── folders-screen.dart
│       └── widgets/
│           ├── folder-list-tile-widget.dart
│           ├── folder-create-dialog-widget.dart
│           └── app-drawer-widget.dart    # main drawer/sidebar
├── tags/
│   ├── domain/
│   │   ├── tag-entity.dart              # (Phase 2)
│   │   └── tag-repository.dart         # (Phase 2)
│   ├── data/
│   │   └── tag-repository-impl.dart    # (Phase 2)
│   └── presentation/
│       ├── providers/
│       │   └── tags-provider.dart
│       └── widgets/
│           ├── tag-chip-widget.dart
│           └── tag-picker-bottom-sheet-widget.dart
```

## Related Code Files

### Create
- `lib/features/folders/presentation/providers/folders-provider.dart`
- `lib/features/folders/presentation/screens/folders-screen.dart`
- `lib/features/folders/presentation/widgets/folder-list-tile-widget.dart`
- `lib/features/folders/presentation/widgets/folder-create-dialog-widget.dart`
- `lib/features/folders/presentation/widgets/app-drawer-widget.dart`
- `lib/features/folders/data/folder-datasource.dart`
- `lib/features/tags/presentation/providers/tags-provider.dart`
- `lib/features/tags/presentation/widgets/tag-chip-widget.dart`
- `lib/features/tags/presentation/widgets/tag-picker-bottom-sheet-widget.dart`

### Modify
- `lib/features/notes/presentation/screens/notes-list-screen.dart` — add drawer
- `lib/features/notes/presentation/screens/note-editor-screen.dart` — add tags + folder picker
- `lib/core/router/app-router.dart` — add folder route

## Implementation Steps

### 1. Folders Provider
```dart
// lib/features/folders/presentation/providers/folders-provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'folders-provider.g.dart';

@riverpod
Stream<List<FolderEntity>> foldersList(FoldersListRef ref) {
  return ref.watch(folderRepositoryProvider).watchFolders();
}

@riverpod
Stream<int> folderNoteCount(FolderNoteCountRef ref, String folderId) {
  return ref.watch(noteRepositoryProvider)
    .watchNotes(folderId: folderId)
    .map((notes) => notes.length);
}

// Selected folder for filtering notes list
@riverpod
class SelectedFolder extends _$SelectedFolder {
  @override
  String? build() => null; // null = All Notes

  void select(String? folderId) => state = folderId;
}
```

### 2. App Drawer Widget (Main Navigation)
```dart
// lib/features/folders/presentation/widgets/app-drawer-widget.dart
class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersListProvider);
    final selectedFolder = ref.watch(selectedFolderProvider);

    return NavigationDrawer(
      selectedIndex: _getSelectedIndex(selectedFolder, foldersAsync.valueOrNull),
      onDestinationSelected: (index) =>
          _handleSelection(context, ref, index, foldersAsync.valueOrNull),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        // All Notes
        const NavigationDrawerDestination(
          icon: Icon(Icons.notes_outlined),
          selectedIcon: Icon(Icons.notes),
          label: Text('All Notes'),
        ),
        const Divider(indent: 28, endIndent: 28),
        // Folders
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 16, 4),
          child: Text('Folders', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        ...?foldersAsync.valueOrNull?.map((f) => NavigationDrawerDestination(
          icon: Text(f.icon, style: const TextStyle(fontSize: 20)),
          label: Row(children: [
            Expanded(child: Text(f.name)),
            _FolderCountBadge(folderId: f.id),
          ]),
        )),
        // Recently Deleted
        const Divider(indent: 28, endIndent: 28),
        const NavigationDrawerDestination(
          icon: Icon(Icons.delete_outline),
          label: Text('Recently Deleted'),
        ),
        // Add Folder button
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () => _showCreateFolderDialog(context, ref),
            icon: const Icon(Icons.create_new_folder_outlined),
            label: const Text('New Folder'),
          ),
        ),
      ],
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => const FolderCreateDialogWidget(),
    );
  }
}
```

### 3. Folder Create Dialog
```dart
// lib/features/folders/presentation/widgets/folder-create-dialog-widget.dart
class FolderCreateDialogWidget extends ConsumerStatefulWidget {
  final FolderEntity? existingFolder; // non-null = rename mode
  const FolderCreateDialogWidget({super.key, this.existingFolder});

  @override
  ConsumerState<FolderCreateDialogWidget> createState() => _State();
}

class _State extends ConsumerState<FolderCreateDialogWidget> {
  late TextEditingController _nameCtrl;
  String _selectedIcon = '📁';

  // Preset folder icons
  static const _icons = ['📁', '📔', '📚', '🏠', '💼', '🎨', '🔬', '💡', '✈️', '🎵'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingFolder?.name ?? '');
    _selectedIcon = widget.existingFolder?.icon ?? '📁';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingFolder == null ? 'New Folder' : 'Rename Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Folder name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          // Icon picker row
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _icons.map((icon) => GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: Container(
                  width: 44, height: 44,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: _selectedIcon == icon
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.existingFolder == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(folderRepositoryProvider);
    if (widget.existingFolder == null) {
      await repo.createFolder(FolderEntity(
        id: const Uuid().v4(),
        name: name,
        icon: _selectedIcon,
        color: '#607D8B',
        createdAt: DateTime.now(),
      ));
    } else {
      await repo.renameFolder(widget.existingFolder!.id, name, _selectedIcon);
    }
    if (mounted) Navigator.pop(context);
  }
}
```

### 4. Tags Provider
```dart
// lib/features/tags/presentation/providers/tags-provider.dart
@riverpod
Stream<List<TagEntity>> tagsList(TagsListRef ref) {
  return ref.watch(tagRepositoryProvider).watchTags();
}

@riverpod
class NoteTagsEditor extends _$NoteTagsEditor {
  @override
  List<String> build(String noteId) => [];

  Future<void> loadForNote(String noteId) async {
    final note = await ref.read(noteRepositoryProvider).getNoteById(noteId);
    state = note?.tagIds ?? [];
  }

  Future<void> toggleTag(String tagId, String noteId) async {
    final newList = state.contains(tagId)
        ? state.where((t) => t != tagId).toList()
        : [...state, tagId];
    state = newList;
    // Update note in DB
    final note = await ref.read(noteRepositoryProvider).getNoteById(noteId);
    if (note != null) {
      await ref.read(noteRepositoryProvider).updateNote(
        note.copyWith(tagIds: newList),
      );
    }
  }
}
```

### 5. Tag Picker Bottom Sheet
```dart
// lib/features/tags/presentation/widgets/tag-picker-bottom-sheet-widget.dart
class TagPickerBottomSheet extends ConsumerWidget {
  final String noteId;
  const TagPickerBottomSheet({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsListProvider);
    final selectedTags = ref.watch(noteTagsEditorProvider(noteId));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      builder: (_, controller) => Column(
        children: [
          // Handle bar
          Container(width: 40, height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton.icon(
                  onPressed: () => _showCreateTag(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('New Tag'),
                ),
              ],
            ),
          ),
          Expanded(
            child: tagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (tags) => ListView.builder(
                controller: controller,
                itemCount: tags.length,
                itemBuilder: (_, i) {
                  final tag = tags[i];
                  final isSelected = selectedTags.contains(tag.id);
                  return CheckboxListTile(
                    value: isSelected,
                    title: TagChipWidget(tag: tag),
                    onChanged: (_) => ref
                        .read(noteTagsEditorProvider(noteId).notifier)
                        .toggleTag(tag.id, noteId),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 6. Folder Delete Logic (move notes to root)
```dart
// In folder-repository-impl.dart
Future<void> deleteFolder(String folderId) async {
  await _db.writeTxn(() async {
    // Find all notes in this folder
    final notes = await _db.noteIsarModels
        .filter()
        .folder((f) => f.uuidEqualTo(folderId))
        .findAll();
    // Remove folder link from all notes
    for (final note in notes) {
      note.folder.reset();
      await _db.noteIsarModels.put(note);
    }
    // Delete the folder
    final folder = await _db.folderIsarModels
        .filter().uuidEqualTo(folderId).findFirst();
    if (folder != null) {
      await _db.folderIsarModels.delete(folder.id);
    }
  });
}
```

### 7. Recently Deleted Logic
```dart
// In note-repository-impl.dart
// Auto-purge notes deleted > 30 days
Future<void> purgeOldDeletedNotes() async {
  final cutoff = DateTime.now().subtract(const Duration(days: 30));
  final toDelete = await _db.noteIsarModels
      .filter()
      .isDeletedEqualTo(true)
      .updatedAtLessThan(cutoff)
      .findAll();
  await _db.writeTxn(() async {
    for (final note in toDelete) {
      await _db.noteIsarModels.delete(note.id);
    }
  });
}
```

## Todo List

- [ ] Implement `folders-provider.dart` (stream + selectedFolder state)
- [ ] Implement `app-drawer-widget.dart` với NavigationDrawer
- [ ] Implement `folder-list-tile-widget.dart` với note count badge
- [ ] Implement `folder-create-dialog-widget.dart` với icon picker
- [ ] Implement `folder-datasource.dart` (create/rename/delete)
- [ ] Implement folder delete với note migration to root
- [ ] Implement `tags-provider.dart` + `NoteTagsEditor`
- [ ] Implement `tag-chip-widget.dart`
- [ ] Implement `tag-picker-bottom-sheet-widget.dart`
- [ ] Add "Tags" button trong note editor AppBar
- [ ] Add "Move to Folder" option trong note options menu
- [ ] Implement "Recently Deleted" pseudo-folder
- [ ] Add auto-purge (30 days) trigger on app start
- [ ] Update `notes-list-screen.dart` → add drawer
- [ ] Update `notes-list-screen.dart` → filter by selectedFolder/tag
- [ ] Add folder route `/folders` → `FoldersScreen`
- [ ] Test: create folder → notes move → delete folder → notes in "All Notes"
- [ ] Test: assign tags → filter by tag → correct notes shown

## Success Criteria

- Drawer hiển thị đúng folders với note count
- Tạo/đổi tên/xóa folder hoạt động
- Gán tag cho note → filter theo tag → đúng kết quả
- "Recently Deleted" hiển thị notes đã xóa
- Auto-purge notes > 30 days

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| IsarLinks lazy loading trong folder delete | High | Luôn `.load()` links trước transaction |
| NavigationDrawer trên Desktop/Tablet | Medium | Dùng `NavigationRail` cho wide screen |
| Tag count không update realtime | Low | Dùng Stream watch, không cache count |

## Security Considerations

- Folder/tag names: sanitize (trim, max 100 chars)
- Không expose folder IDs trong URL plainly

## Next Steps

→ Phase 5: Search & Filtering
