import 'note-entity.dart';

/// Abstract repository contract for Note operations.
abstract class NoteRepository {
  Future<List<NoteEntity>> getAllNotes({String? folderId, bool includeDeleted = false});
  Future<NoteEntity?> getNoteById(String id);
  Future<NoteEntity> createNote(NoteEntity note);
  Future<NoteEntity> updateNote(NoteEntity note);
  Future<void> deleteNote(String id); // soft delete
  Future<void> restoreNote(String id); // undo soft delete
  Future<void> permanentlyDeleteNote(String id);
  Future<List<NoteEntity>> searchNotes(String query);
  Stream<List<NoteEntity>> watchNotes({String? folderId});
  Future<void> purgeOldDeletedNotes(); // purge notes deleted > 30 days
}
