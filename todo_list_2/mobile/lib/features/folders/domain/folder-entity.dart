/// Pure Dart domain entity for a Folder.
class FolderEntity {
  final String id;
  final String name;
  final String icon;
  final String color;
  final DateTime createdAt;

  const FolderEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.createdAt,
  });

  FolderEntity copyWith({String? name, String? icon, String? color}) {
    return FolderEntity(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }
}
