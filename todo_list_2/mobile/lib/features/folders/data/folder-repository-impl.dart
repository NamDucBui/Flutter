import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/objectbox-service.dart';
import '../../../core/database/models/folder-model.dart';
import '../../../core/database/models/note-model.dart';
import '../../../objectbox.g.dart';
import '../domain/folder-entity.dart';
import '../domain/folder-repository.dart';
import 'folder-mapper.dart';

part 'folder-repository-impl.g.dart';

/// Riverpod provider for FolderRepository.
@riverpod
// ignore: deprecated_member_use_from_same_package
FolderRepository folderRepository(Ref ref) {
  return FolderRepositoryImpl(ObjectBoxService.store);
}

/// ObjectBox implementation of [FolderRepository].
class FolderRepositoryImpl implements FolderRepository {
  final Box<FolderModel> _box;
  final Box<NoteModel> _noteBox;

  FolderRepositoryImpl(Store store)
      : _box = store.box<FolderModel>(),
        _noteBox = store.box<NoteModel>();

  @override
  Future<List<FolderEntity>> getAllFolders() async {
    final results = _box.getAll();
    results.sort((a, b) => a.name.compareTo(b.name));
    return results.map(FolderMapper.toEntity).toList();
  }

  @override
  Future<FolderEntity?> getFolderById(String id) async {
    final result =
        _box.query(FolderModel_.uuid.equals(id)).build().findFirst();
    return result != null ? FolderMapper.toEntity(result) : null;
  }

  @override
  Future<FolderEntity> createFolder(FolderEntity folder) async {
    final model = FolderMapper.toModel(folder);
    _box.put(model);
    return FolderMapper.toEntity(model);
  }

  @override
  Future<FolderEntity> updateFolder(FolderEntity folder) async {
    final existing =
        _box.query(FolderModel_.uuid.equals(folder.id)).build().findFirst();
    final model = FolderMapper.toModel(folder);
    if (existing != null) model.id = existing.id;
    _box.put(model);
    return FolderMapper.toEntity(model);
  }

  @override
  Future<void> deleteFolder(String id) async {
    // Move all notes in this folder back to "All Notes" (root)
    final notes =
        _noteBox.query(NoteModel_.folderUuid.equals(id)).build().find();
    for (final note in notes) {
      note.folderUuid = null;
      _noteBox.put(note);
    }
    final folder =
        _box.query(FolderModel_.uuid.equals(id)).build().findFirst();
    if (folder != null) _box.remove(folder.id);
  }

  @override
  Stream<List<FolderEntity>> watchFolders() {
    return _box.query().watch(triggerImmediately: true).map((q) {
      final results = q.find();
      results.sort((a, b) => a.name.compareTo(b.name));
      return results.map(FolderMapper.toEntity).toList();
    });
  }
}
