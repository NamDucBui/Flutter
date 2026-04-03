import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show TextSelection;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/note-entity.dart';
import '../../data/note-repository-impl.dart';

part 'note-editor-provider.g.dart';

/// Manages note editor state with auto-save (debounced 500ms).
@riverpod
class NoteEditor extends _$NoteEditor {
  Timer? _debounce;
  QuillController? _quillController;

  /// Exposes the underlying [QuillController] for the editor widget.
  /// Returns null while the controller is being initialised.
  QuillController? get controller => _quillController;

  @override
  AsyncValue<NoteEntity?> build(String? noteId) {
    ref.onDispose(() {
      _debounce?.cancel();
      _quillController?.dispose();
    });
    _initController(noteId);
    return const AsyncValue.loading();
  }

  Future<void> _initController(String? noteId) async {
    if (noteId != null && noteId != 'new') {
      final note = await ref.read(noteRepositoryProvider).getNoteById(noteId);
      if (note != null) {
        final doc = note.richContent.isNotEmpty
            ? Document.fromJson(jsonDecode(note.richContent) as List)
            : Document();
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
        _quillController!.changes.listen((_) => _scheduleSave());
        state = AsyncValue.data(note);
        return;
      }
    }
    _quillController = QuillController.basic();
    _quillController!.changes.listen((_) => _scheduleSave());
    state = const AsyncValue.data(null);
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _save);
  }

  Future<void> _save() async {
    if (!ref.mounted) return;
    final plainText = _quillController!.document.toPlainText().trim();
    if (plainText.isEmpty) return;

    final lines = plainText.split('\n');
    final title = lines.first.trim().isEmpty ? 'Untitled' : lines.first.trim();
    final richJson =
        jsonEncode(_quillController!.document.toDelta().toJson());

    final current = state.value;
    final repo = ref.read(noteRepositoryProvider);

    if (current == null) {
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
      final saved = await repo.createNote(newNote);
      state = AsyncValue.data(saved);
    } else {
      final updated = current.copyWith(
        title: title,
        plainContent: plainText,
        richContent: richJson,
      );
      await repo.updateNote(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Toggles the pin state of the current note.
  Future<void> togglePin() async {
    final note = state.value;
    if (note == null) return;
    final updated = note.copyWith(isPinned: !note.isPinned);
    await ref.read(noteRepositoryProvider).updateNote(updated);
    state = AsyncValue.data(updated);
  }

  /// Updates the background color of the current note.
  Future<void> setColor(String color) async {
    final note = state.value;
    if (note == null) return;
    final updated = note.copyWith(color: color);
    await ref.read(noteRepositoryProvider).updateNote(updated);
    state = AsyncValue.data(updated);
  }
}
