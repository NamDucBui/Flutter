import '../domain/folder-entity.dart';
import '../../../core/database/models/folder-model.dart';

/// Maps between FolderModel (ObjectBox) and FolderEntity (domain).
class FolderMapper {
  const FolderMapper._();

  static FolderEntity toEntity(FolderModel model) {
    return FolderEntity(
      id: model.uuid,
      name: model.name,
      icon: model.icon,
      color: model.color,
      createdAt: model.createdAt,
    );
  }

  static FolderModel toModel(FolderEntity entity) {
    return FolderModel()
      ..uuid = entity.id
      ..name = entity.name
      ..icon = entity.icon
      ..color = entity.color
      ..createdAt = entity.createdAt;
  }
}
