import 'package:objectbox/objectbox.dart';

/// ObjectBox entity for a Note document.
@Entity()
class NoteModel {
  @Id()
  int id = 0;

  /// UUID v4 — cross-platform stable identifier
  @Unique()
  late String uuid;

  @Index()
  late String title;

  /// Plain text extracted from rich content — used for search
  @Index()
  late String plainContent;

  /// Quill Delta JSON — used for rich text display
  late String richContent;

  @Property(type: PropertyType.date)
  late DateTime createdAt;

  @Property(type: PropertyType.date)
  late DateTime updatedAt;

  late bool isPinned;

  /// Soft delete flag
  late bool isDeleted;

  /// Hex color string, e.g. "#FFFFFF"
  late String color;

  /// FK to folder UUID (null = no folder)
  String? folderUuid;

  /// Comma-separated tag UUIDs (simple denormalization)
  String tagUuids = ''; // e.g. "uuid1,uuid2"

  NoteModel();
}
