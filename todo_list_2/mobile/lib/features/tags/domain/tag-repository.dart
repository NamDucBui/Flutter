import 'tag-entity.dart';

/// Abstract repository contract for Tag operations.
abstract class TagRepository {
  Future<List<TagEntity>> getAllTags();
  Future<TagEntity?> getTagById(String id);
  Future<TagEntity> createTag(TagEntity tag);
  Future<void> deleteTag(String id);
  Stream<List<TagEntity>> watchTags();
}
