import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/objectbox-service.dart';
import '../../../core/database/models/note-model.dart';
import '../../../objectbox.g.dart';
import '../domain/note-entity.dart';
import '../domain/note-repository.dart';
import 'note-mapper.dart';

part 'note-repository-impl.g.dart';

/// Riverpod provider for NoteRepository.
@riverpod
// ignore: deprecated_member_use_from_same_package
NoteRepository noteRepository(Ref ref) {
  return NoteRepositoryImpl(ObjectBoxService.store);
}

/// ObjectBox implementation of [NoteRepository].
class NoteRepositoryImpl implements NoteRepository {
  final Box<NoteModel> _box;

  NoteRepositoryImpl(Store store) : _box = store.box<NoteModel>();

  @override
  Future<List<NoteEntity>> getAllNotes({
    String? folderId,
    bool includeDeleted = false,
  }) async {
    QueryBuilder<NoteModel> query;
    if (folderId != null) {
      query = _box.query(
        NoteModel_.isDeleted.equals(false) &
            NoteModel_.folderUuid.equals(folderId),
      );
    } else {
      query = includeDeleted
          ? _box.query()
          : _box.query(NoteModel_.isDeleted.equals(false));
    }
    final results = query.build().find();
    results.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return results.map(NoteMapper.toEntity).toList();
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    final result = _box.query(NoteModel_.uuid.equals(id)).build().findFirst();
    return result != null ? NoteMapper.toEntity(result) : null;
  }

  @override
  Future<NoteEntity> createNote(NoteEntity note) async {
    final model = NoteMapper.toModel(note);
    _box.put(model);
    return NoteMapper.toEntity(model);
  }

  @override
  Future<NoteEntity> updateNote(NoteEntity note) async {
    final existing =
        _box.query(NoteModel_.uuid.equals(note.id)).build().findFirst();
    final model = NoteMapper.toModel(note);
    if (existing != null) model.id = existing.id;
    _box.put(model);
    return NoteMapper.toEntity(model);
  }

  @override
  Future<void> deleteNote(String id) async {
    final model = _box.query(NoteModel_.uuid.equals(id)).build().findFirst();
    if (model != null) {
      model.isDeleted = true;
      model.updatedAt = DateTime.now();
      _box.put(model);
    }
  }

  @override
  Future<void> restoreNote(String id) async {
    final model = _box.query(NoteModel_.uuid.equals(id)).build().findFirst();
    if (model != null) {
      model.isDeleted = false;
      model.updatedAt = DateTime.now();
      _box.put(model);
    }
  }

  @override
  Future<void> permanentlyDeleteNote(String id) async {
    final model = _box.query(NoteModel_.uuid.equals(id)).build().findFirst();
    if (model != null) _box.remove(model.id);
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    if (query.trim().isEmpty) return [];
    final results = _box
        .query(
          NoteModel_.isDeleted.equals(false) &
              (NoteModel_.title.contains(query) |
                  NoteModel_.plainContent.contains(query)),
        )
        .build()
        .find();
    // Post-filter for case-insensitive match (ObjectBox .contains is case-sensitive)
    final lower = query.toLowerCase();
    final filtered = results.where((m) =>
        m.title.toLowerCase().contains(lower) ||
        m.plainContent.toLowerCase().contains(lower)).toList();
    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return filtered.map(NoteMapper.toEntity).toList();
  }

  @override
  Stream<List<NoteEntity>> watchNotes({String? folderId}) {
    final condition = folderId != null
        ? NoteModel_.isDeleted.equals(false) &
            NoteModel_.folderUuid.equals(folderId)
        : NoteModel_.isDeleted.equals(false);
    return _box.query(condition).watch(triggerImmediately: true).map((q) {
      final results = q.find();
      results.sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
      return results.map(NoteMapper.toEntity).toList();
    });
  }

  @override
  Future<void> purgeOldDeletedNotes() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final toDelete = _box
        .query(
          NoteModel_.isDeleted.equals(true) &
              NoteModel_.updatedAt
                  .lessThan(cutoff.millisecondsSinceEpoch),
        )
        .build()
        .find();
    _box.removeMany(toDelete.map((m) => m.id).toList());
  }
}
