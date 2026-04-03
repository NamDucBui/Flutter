import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/features/notes/domain/note-entity.dart';

void main() {
  final base = NoteEntity(
    id: 'test-uuid',
    title: 'Test',
    plainContent: 'Hello world',
    richContent: '{}',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    isPinned: false,
    isDeleted: false,
    color: '#FFFFFF',
  );

  group('NoteEntity', () {
    test('copyWith updates title and bumps updatedAt', () {
      final updated = base.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.id, base.id);
      expect(updated.updatedAt.isAfter(base.updatedAt), isTrue);
    });

    test('copyWith preserves unmodified fields', () {
      final updated = base.copyWith(isPinned: true);
      expect(updated.plainContent, base.plainContent);
      expect(updated.isPinned, isTrue);
      expect(updated.id, base.id);
    });

    test('copyWith with clearFolder removes folderId', () {
      final withFolder = base.copyWith(folderId: 'folder-1');
      expect(withFolder.folderId, 'folder-1');

      final cleared = withFolder.copyWith(clearFolder: true);
      expect(cleared.folderId, isNull);
    });

    test('copyWith without clearFolder preserves existing folderId', () {
      final withFolder = base.copyWith(folderId: 'folder-1');
      final updated = withFolder.copyWith(title: 'Changed');
      expect(updated.folderId, 'folder-1');
    });

    test('id is immutable across copyWith chain', () {
      final a = base.copyWith(title: 'A');
      final b = a.copyWith(plainContent: 'B');
      expect(b.id, base.id);
    });

    test('createdAt is immutable across copyWith', () {
      final updated = base.copyWith(title: 'Updated');
      expect(updated.createdAt, base.createdAt);
    });
  });
}
