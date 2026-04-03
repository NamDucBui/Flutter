import 'package:objectbox/objectbox.dart';

/// ObjectBox entity for a Folder.
@Entity()
class FolderModel {
  @Id()
  int id = 0;

  @Unique()
  late String uuid;

  @Index()
  late String name;

  /// Emoji or icon name, e.g. "📁"
  late String icon;

  /// Hex color string
  late String color;

  @Property(type: PropertyType.date)
  late DateTime createdAt;

  FolderModel();
}
