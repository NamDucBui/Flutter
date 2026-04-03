import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../notes/domain/note-entity.dart';
import '../../../notes/data/note-repository-impl.dart';
import 'search-filters-provider.dart';

part 'search-provider.g.dart';

/// Debounced search query state (300ms).
@riverpod
class SearchQuery extends _$SearchQuery {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  void update(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = query;
      if (query.trim().isNotEmpty) _saveRecent(query.trim());
    });
  }

  void clear() {
    _debounce?.cancel();
    state = '';
  }

  Future<void> _saveRecent(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_searches') ?? [];
    list.remove(query);
    list.insert(0, query);
    if (list.length > 10) list.removeLast();
    await prefs.setStringList('recent_searches', list);
  }
}

/// Persisted recent search queries.
@riverpod
Future<List<String>> recentSearches(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('recent_searches') ?? [];
}

/// Search results filtered by active filters.
@riverpod
Future<List<NoteEntity>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  final filters = ref.watch(searchFiltersProvider);

  if (query.trim().isEmpty) return [];

  var results = await ref.read(noteRepositoryProvider).searchNotes(query);

  if (filters.folderId != null) {
    results = results.where((n) => n.folderId == filters.folderId).toList();
  }
  if (filters.tagId != null) {
    results = results.where((n) => n.tagIds.contains(filters.tagId)).toList();
  }
  if (filters.pinnedOnly) {
    results = results.where((n) => n.isPinned).toList();
  }
  return results;
}
