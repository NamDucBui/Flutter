import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/note-entity.dart';
import '../../data/note-repository-impl.dart';

part 'notes-list-provider.g.dart';

/// Streams all non-deleted notes, optionally filtered by folder.
@riverpod
Stream<List<NoteEntity>> notesList(Ref ref, {String? folderId}) {
  return ref.watch(noteRepositoryProvider).watchNotes(folderId: folderId);
}

/// Splits notes into pinned and regular sections.
@riverpod
AsyncValue<(List<NoteEntity>, List<NoteEntity>)> pinnedAndNotes(
  Ref ref, {
  String? folderId,
}) {
  return ref.watch(notesListProvider(folderId: folderId)).whenData((notes) {
    final pinned = notes.where((n) => n.isPinned).toList();
    final regular = notes.where((n) => !n.isPinned).toList();
    return (pinned, regular);
  });
}
