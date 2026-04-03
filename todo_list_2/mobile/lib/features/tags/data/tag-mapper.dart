import '../domain/tag-entity.dart';
import '../../../core/database/models/tag-model.dart';

/// Maps between TagModel (ObjectBox) and TagEntity (domain).
class TagMapper {
  const TagMapper._();

  static TagEntity toEntity(TagModel model) {
    return TagEntity(id: model.uuid, name: model.name, color: model.color);
  }

  static TagModel toModel(TagEntity entity) {
    return TagModel()
      ..uuid = entity.id
      ..name = entity.name
      ..color = entity.color;
  }
}
