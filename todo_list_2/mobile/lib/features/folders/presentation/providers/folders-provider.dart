import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/folder-entity.dart';
import '../../data/folder-repository-impl.dart';
import '../../../notes/data/note-repository-impl.dart';

part 'folders-provider.g.dart';

/// Streams all folders sorted alphabetically.
@riverpod
Stream<List<FolderEntity>> foldersList(Ref ref) {
  return ref.watch(folderRepositoryProvider).watchFolders();
}

/// Streams note count for a specific folder.
@riverpod
Stream<int> folderNoteCount(Ref ref, String folderId) {
  return ref
      .watch(noteRepositoryProvider)
      .watchNotes(folderId: folderId)
      .map((notes) => notes.length);
}

/// Currently selected folder UUID for filtering the notes list. null = All Notes.
@riverpod
class SelectedFolder extends _$SelectedFolder {
  @override
  String? build() => null;

  void select(String? folderId) => state = folderId;
}
