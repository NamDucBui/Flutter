import 'package:objectbox/objectbox.dart';

/// ObjectBox entity for a Tag.
@Entity()
class TagModel {
  @Id()
  int id = 0;

  @Unique()
  late String uuid;

  @Unique()
  @Index()
  late String name;

  /// Hex color string
  late String color;

  TagModel();
}
