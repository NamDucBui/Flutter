/// Pure Dart domain entity for a Note — no framework dependencies.
class NoteEntity {
  final String id; // UUID
  final String title;
  final String plainContent;
  final String richContent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isDeleted;
  final String color;
  final String? folderId; // folder UUID or null
  final List<String> tagIds;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.plainContent,
    required this.richContent,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    required this.isDeleted,
    required this.color,
    this.folderId,
    this.tagIds = const [],
  });

  NoteEntity copyWith({
    String? title,
    String? plainContent,
    String? richContent,
    bool? isPinned,
    bool? isDeleted,
    String? color,
    String? folderId,
    bool clearFolder = false,
    List<String>? tagIds,
  }) {
    return NoteEntity(
      id: id,
      title: title ?? this.title,
      plainContent: plainContent ?? this.plainContent,
      richContent: richContent ?? this.richContent,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      color: color ?? this.color,
      folderId: clearFolder ? null : (folderId ?? this.folderId),
      tagIds: tagIds ?? this.tagIds,
    );
  }
}
