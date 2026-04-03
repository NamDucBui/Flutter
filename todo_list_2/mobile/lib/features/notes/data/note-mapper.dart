import '../domain/note-entity.dart';
import '../../../core/database/models/note-model.dart';

/// Maps between NoteModel (ObjectBox) and NoteEntity (domain).
class NoteMapper {
  const NoteMapper._();

  static NoteEntity toEntity(NoteModel model) {
    return NoteEntity(
      id: model.uuid,
      title: model.title,
      plainContent: model.plainContent,
      richContent: model.richContent,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isPinned: model.isPinned,
      isDeleted: model.isDeleted,
      color: model.color,
      folderId: model.folderUuid,
      tagIds: model.tagUuids.isEmpty
          ? []
          : model.tagUuids.split(',').where((s) => s.isNotEmpty).toList(),
    );
  }

  static NoteModel toModel(NoteEntity entity) {
    return NoteModel()
      ..uuid = entity.id
      ..title = entity.title
      ..plainContent = entity.plainContent
      ..richContent = entity.richContent
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..isPinned = entity.isPinned
      ..isDeleted = entity.isDeleted
      ..color = entity.color
      ..folderUuid = entity.folderId
      ..tagUuids = entity.tagIds.join(',');
  }
}
