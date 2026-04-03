import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/objectbox-service.dart';
import '../../../core/database/models/tag-model.dart';
import '../../../objectbox.g.dart';
import '../domain/tag-entity.dart';
import '../domain/tag-repository.dart';
import 'tag-mapper.dart';

part 'tag-repository-impl.g.dart';

/// Riverpod provider for TagRepository.
@riverpod
// ignore: deprecated_member_use_from_same_package
TagRepository tagRepository(Ref ref) {
  return TagRepositoryImpl(ObjectBoxService.store);
}

/// ObjectBox implementation of [TagRepository].
class TagRepositoryImpl implements TagRepository {
  final Box<TagModel> _box;

  TagRepositoryImpl(Store store) : _box = store.box<TagModel>();

  @override
  Future<List<TagEntity>> getAllTags() async {
    return _box.getAll().map(TagMapper.toEntity).toList();
  }

  @override
  Future<TagEntity?> getTagById(String id) async {
    final result = _box.query(TagModel_.uuid.equals(id)).build().findFirst();
    return result != null ? TagMapper.toEntity(result) : null;
  }

  @override
  Future<TagEntity> createTag(TagEntity tag) async {
    final model = TagMapper.toModel(tag);
    _box.put(model);
    return TagMapper.toEntity(model);
  }

  @override
  Future<void> deleteTag(String id) async {
    final model = _box.query(TagModel_.uuid.equals(id)).build().findFirst();
    if (model != null) _box.remove(model.id);
  }

  @override
  Stream<List<TagEntity>> watchTags() {
    return _box.query().watch(triggerImmediately: true).map(
          (q) => q.find().map(TagMapper.toEntity).toList(),
        );
  }
}
