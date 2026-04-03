import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search-filters-provider.g.dart';

/// Active filter state for the search screen.
class SearchFilters {
  final String? folderId;
  final String? tagId;
  final bool pinnedOnly;

  const SearchFilters({this.folderId, this.tagId, this.pinnedOnly = false});

  bool get hasActiveFilters => folderId != null || tagId != null || pinnedOnly;

  SearchFilters copyWith({
    String? folderId,
    String? tagId,
    bool? pinnedOnly,
    bool clearFolder = false,
    bool clearTag = false,
  }) {
    return SearchFilters(
      folderId: clearFolder ? null : (folderId ?? this.folderId),
      tagId: clearTag ? null : (tagId ?? this.tagId),
      pinnedOnly: pinnedOnly ?? this.pinnedOnly,
    );
  }

  SearchFilters clear() => const SearchFilters();
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void setFolder(String? id) =>
      state = state.copyWith(folderId: id, clearFolder: id == null);

  void setTag(String? id) =>
      state = state.copyWith(tagId: id, clearTag: id == null);

  void togglePinned() =>
      state = state.copyWith(pinnedOnly: !state.pinnedOnly);

  void clearAll() => state = const SearchFilters();
}
