import 'folder-entity.dart';

/// Abstract repository contract for Folder operations.
abstract class FolderRepository {
  Future<List<FolderEntity>> getAllFolders();
  Future<FolderEntity?> getFolderById(String id);
  Future<FolderEntity> createFolder(FolderEntity folder);
  Future<FolderEntity> updateFolder(FolderEntity folder);
  Future<void> deleteFolder(String id); // moves notes to root
  Stream<List<FolderEntity>> watchFolders();
}
