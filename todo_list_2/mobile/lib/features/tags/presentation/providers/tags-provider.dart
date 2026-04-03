import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/tag-entity.dart';
import '../../data/tag-repository-impl.dart';
import '../../../notes/data/note-repository-impl.dart';

part 'tags-provider.g.dart';

/// Streams all tags.
@riverpod
Stream<List<TagEntity>> tagsList(Ref ref) {
  return ref.watch(tagRepositoryProvider).watchTags();
}

/// Manages which tag UUIDs are assigned to a specific note.
@riverpod
class NoteTagsEditor extends _$NoteTagsEditor {
  @override
  List<String> build(String noteId) {
    // Load initial tag list for this note
    _load(noteId);
    return [];
  }

  Future<void> _load(String noteId) async {
    final note = await ref.read(noteRepositoryProvider).getNoteById(noteId);
    state = note?.tagIds ?? [];
  }

  Future<void> toggleTag(String tagId, String noteId) async {
    final newList = state.contains(tagId)
        ? state.where((t) => t != tagId).toList()
        : [...state, tagId];
    state = newList;
    final note = await ref.read(noteRepositoryProvider).getNoteById(noteId);
    if (note != null) {
      await ref.read(noteRepositoryProvider).updateNote(
            note.copyWith(tagIds: newList),
          );
    }
  }
}
