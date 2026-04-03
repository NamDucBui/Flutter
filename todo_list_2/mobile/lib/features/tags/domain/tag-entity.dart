/// Pure Dart domain entity for a Tag.
class TagEntity {
  final String id;
  final String name;
  final String color;

  const TagEntity({
    required this.id,
    required this.name,
    required this.color,
  });

  TagEntity copyWith({String? name, String? color}) {
    return TagEntity(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
