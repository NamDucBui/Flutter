# Phase 5: Search & Filtering

**Plan:** [Flutter Notes App MVP](./plan.md)
**Status:** Pending | **Priority:** P2 | **Est:** 10h
**Blocked by:** Phase 4 (Folders & Tags)

## Overview

Implement full-text search với Isar's built-in fullText index, real-time search results, match highlighting, và filter chips (by folder, tag, date range, color).

## Key Insights

- Isar `IndexType.fullText` đã setup ở Phase 2 → search `title` + `plainContent` natively
- Search debounce 300ms (khác auto-save 500ms) — search nhanh hơn
- Match highlighting: compare plain text với query string, wrap với background color span
- Search screen separate với notes list screen — không filter in-place
- Recent searches: lưu vào `shared_preferences` (last 10 queries)
- Filter chips: folder filter, tag filter, color filter, pinned-only filter

## Requirements

### Functional
- [ ] Search bar (full-screen SearchAnchor hoặc SearchBar)
- [ ] Real-time results khi gõ (debounce 300ms)
- [ ] Search in: title + content (plainContent)
- [ ] Highlight matching text trong kết quả
- [ ] Recent searches (last 10, tap to re-search)
- [ ] Filter chips: by folder, by tag, by color, pinned only
- [ ] Empty state: "No results for '...'"
- [ ] Result count display: "5 notes found"
- [ ] Search result card: show matched snippet with highlight
- [ ] Clear search button (X)

### Non-functional
- Search results < 100ms cho local Isar query
- Debounce prevents excessive DB calls
- Recent searches persist across sessions

## Architecture

```
lib/features/search/
├── presentation/
│   ├── providers/
│   │   ├── search-provider.dart          # search query + results state
│   │   └── search-filters-provider.dart  # active filter chips state
│   ├── screens/
│   │   └── search-screen.dart
│   └── widgets/
│       ├── search-result-card-widget.dart   # card với highlighted text
│       ├── search-filter-chips-widget.dart  # folder/tag/color chips
│       ├── recent-searches-widget.dart      # recent search suggestions
│       └── search-highlight-text-widget.dart # RichText với highlights
```

## Implementation Steps

### 1. Search Provider
```dart
// lib/features/search/presentation/providers/search-provider.dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'search-provider.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  Timer? _debounce;

  @override
  String build() => '';

  void update(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = query;
      if (query.trim().isNotEmpty) _saveToRecent(query.trim());
    });
  }

  void clear() {
    _debounce?.cancel();
    state = '';
  }

  Future<void> _saveToRecent(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = prefs.getStringList('recent_searches') ?? [];
    recent.remove(query); // dedup
    recent.insert(0, query);
    if (recent.length > 10) recent.removeLast();
    await prefs.setStringList('recent_searches', recent);
  }
}

@riverpod
Future<List<String>> recentSearches(RecentSearchesRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('recent_searches') ?? [];
}

@riverpod
Future<List<NoteEntity>> searchResults(SearchResultsRef ref) async {
  final query = ref.watch(searchQueryProvider);
  final filters = ref.watch(searchFiltersProvider);

  if (query.trim().isEmpty) return [];

  var results = await ref.read(noteRepositoryProvider).searchNotes(query);

  // Apply filters
  if (filters.folderId != null) {
    results = results.where((n) => n.folderId == filters.folderId).toList();
  }
  if (filters.tagId != null) {
    results = results.where((n) => n.tagIds.contains(filters.tagId)).toList();
  }
  if (filters.color != null) {
    results = results.where((n) => n.color == filters.color).toList();
  }
  if (filters.pinnedOnly) {
    results = results.where((n) => n.isPinned).toList();
  }

  return results;
}
```

### 2. Search Filters State
```dart
// lib/features/search/presentation/providers/search-filters-provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search-filters-provider.g.dart';

class SearchFilters {
  final String? folderId;
  final String? tagId;
  final String? color;
  final bool pinnedOnly;

  const SearchFilters({
    this.folderId,
    this.tagId,
    this.color,
    this.pinnedOnly = false,
  });

  bool get hasActiveFilters =>
      folderId != null || tagId != null || color != null || pinnedOnly;

  SearchFilters copyWith({
    String? folderId,
    String? tagId,
    String? color,
    bool? pinnedOnly,
    bool clearFolder = false,
    bool clearTag = false,
    bool clearColor = false,
  }) {
    return SearchFilters(
      folderId: clearFolder ? null : (folderId ?? this.folderId),
      tagId: clearTag ? null : (tagId ?? this.tagId),
      color: clearColor ? null : (color ?? this.color),
      pinnedOnly: pinnedOnly ?? this.pinnedOnly,
    );
  }

  SearchFilters clear() => const SearchFilters();
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void setFolder(String? folderId) =>
      state = state.copyWith(folderId: folderId, clearFolder: folderId == null);

  void setTag(String? tagId) =>
      state = state.copyWith(tagId: tagId, clearTag: tagId == null);

  void setColor(String? color) =>
      state = state.copyWith(color: color, clearColor: color == null);

  void togglePinned() =>
      state = state.copyWith(pinnedOnly: !state.pinnedOnly);

  void clearAll() => state = const SearchFilters();
}
```

### 3. Search Screen
```dart
// lib/features/search/presentation/screens/search-screen.dart
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchCtrl = SearchController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Search app bar
          SliverAppBar(
            floating: true,
            title: SearchBar(
              controller: _searchCtrl,
              hintText: 'Search notes...',
              leading: const Icon(Icons.search),
              trailing: [
                if (query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchCtrl.clear();
                      ref.read(searchQueryProvider.notifier).clear();
                    },
                  ),
              ],
              onChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).update(q),
            ),
          ),
          // Filter chips
          SliverToBoxAdapter(
            child: SearchFilterChipsWidget(filters: filters),
          ),
          // Results count
          if (query.isNotEmpty)
            SliverToBoxAdapter(
              child: resultsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (r) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    '${r.length} note${r.length == 1 ? '' : 's'} found',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          // Content
          if (query.isEmpty)
            SliverToBoxAdapter(child: RecentSearchesWidget(
              onTap: (q) {
                _searchCtrl.text = q;
                ref.read(searchQueryProvider.notifier).update(q);
              },
            ))
          else
            resultsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
              data: (results) => results.isEmpty
                  ? SliverFillRemaining(
                      child: _EmptySearchState(query: query),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => SearchResultCardWidget(
                          note: results[i],
                          query: query,
                          onTap: () => context.push('/notes/${results[i].id}'),
                        ),
                        childCount: results.length,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
```

### 4. Search Highlight Text Widget
```dart
// lib/features/search/presentation/widgets/search-highlight-text-widget.dart
class SearchHighlightTextWidget extends StatelessWidget {
  final String text;
  final String query;
  final int maxLines;
  final TextStyle? style;

  const SearchHighlightTextWidget({
    super.key,
    required this.text,
    required this.query,
    this.maxLines = 3,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style);
    }
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: _buildSpans(context),
      ),
    );
  }

  List<TextSpan> _buildSpans(BuildContext context) {
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lower.indexOf(queryLower, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = index + query.length;
    }
    return spans;
  }
}
```

### 5. Search Result Card Widget
```dart
// lib/features/search/presentation/widgets/search-result-card-widget.dart
class SearchResultCardWidget extends StatelessWidget {
  final NoteEntity note;
  final String query;
  final VoidCallback onTap;

  const SearchResultCardWidget({
    super.key, required this.note,
    required this.query, required this.onTap,
  });

  // Find snippet around first match
  String _getSnippet() {
    final lower = note.plainContent.toLowerCase();
    final idx = lower.indexOf(query.toLowerCase());
    if (idx == -1) return note.plainContent.substring(0, 150.clamp(0, note.plainContent.length));
    final start = (idx - 60).clamp(0, note.plainContent.length);
    final end = (idx + 120).clamp(0, note.plainContent.length);
    final prefix = start > 0 ? '...' : '';
    return '$prefix${note.plainContent.substring(start, end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchHighlightTextWidget(
                text: note.title.isEmpty ? 'Untitled' : note.title,
                query: query,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (note.plainContent.isNotEmpty) ...[
                const SizedBox(height: 4),
                SearchHighlightTextWidget(
                  text: _getSnippet(),
                  query: query,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 6),
              Text(
                DateFormat('MMM d, y').format(note.updatedAt),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 6. Search Filter Chips Widget
```dart
// lib/features/search/presentation/widgets/search-filter-chips-widget.dart
class SearchFilterChipsWidget extends ConsumerWidget {
  final SearchFilters filters;
  const SearchFilterChipsWidget({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchFiltersProvider.notifier);
    final folders = ref.watch(foldersListProvider).valueOrNull ?? [];
    final tags = ref.watch(tagsListProvider).valueOrNull ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          if (filters.hasActiveFilters)
            ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.close, size: 16),
              onPressed: notifier.clearAll,
            ),
          const SizedBox(width: 4),
          // Pinned filter
          FilterChip(
            label: const Text('Pinned'),
            selected: filters.pinnedOnly,
            onSelected: (_) => notifier.togglePinned(),
          ),
          const SizedBox(width: 4),
          // Folder filter
          ChoiceChip(
            label: Text(filters.folderId != null
                ? (folders.firstWhere((f) => f.id == filters.folderId,
                    orElse: () => FolderEntity(id: '', name: 'Folder', icon: '📁', color: '', createdAt: DateTime.now())).name)
                : 'Folder'),
            selected: filters.folderId != null,
            onSelected: (_) => _showFolderPicker(context, ref, folders),
          ),
          const SizedBox(width: 4),
          // Tag filter
          ChoiceChip(
            label: Text(filters.tagId != null
                ? '#${tags.firstWhere((t) => t.id == filters.tagId, orElse: () => TagEntity(id: '', name: 'Tag', color: '')).name}'
                : 'Tag'),
            selected: filters.tagId != null,
            onSelected: (_) => _showTagPicker(context, ref, tags),
          ),
        ],
      ),
    );
  }

  void _showFolderPicker(BuildContext ctx, WidgetRef ref, List<FolderEntity> folders) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('All Folders'), onTap: () {
            ref.read(searchFiltersProvider.notifier).setFolder(null);
            Navigator.pop(ctx);
          }),
          ...folders.map((f) => ListTile(
            leading: Text(f.icon, style: const TextStyle(fontSize: 20)),
            title: Text(f.name),
            onTap: () {
              ref.read(searchFiltersProvider.notifier).setFolder(f.id);
              Navigator.pop(ctx);
            },
          )),
        ],
      ),
    );
  }

  void _showTagPicker(BuildContext ctx, WidgetRef ref, List<TagEntity> tags) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('All Tags'), onTap: () {
            ref.read(searchFiltersProvider.notifier).setTag(null);
            Navigator.pop(ctx);
          }),
          ...tags.map((t) => ListTile(
            leading: TagChipWidget(tag: t),
            onTap: () {
              ref.read(searchFiltersProvider.notifier).setTag(t.id);
              Navigator.pop(ctx);
            },
          )),
        ],
      ),
    );
  }
}
```

### 7. Recent Searches Widget
```dart
// lib/features/search/presentation/widgets/recent-searches-widget.dart
class RecentSearchesWidget extends ConsumerWidget {
  final ValueChanged<String> onTap;
  const RecentSearchesWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentSearchesProvider);
    return recentAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (recents) {
        if (recents.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Recent', style: Theme.of(context).textTheme.labelSmall),
            ),
            ...recents.map((q) => ListTile(
              leading: const Icon(Icons.history, size: 18),
              title: Text(q),
              onTap: () => onTap(q),
            )),
          ],
        );
      },
    );
  }
}
```

## Todo List

- [ ] Implement `search-provider.dart` (query debounce + results)
- [ ] Implement `search-filters-provider.dart` (SearchFilters model + notifier)
- [ ] Implement `search-screen.dart` với SearchBar + SliverList
- [ ] Implement `search-highlight-text-widget.dart` (RichText highlight)
- [ ] Implement `search-result-card-widget.dart` với snippet extraction
- [ ] Implement `search-filter-chips-widget.dart` (folder/tag/pinned chips)
- [ ] Implement `recent-searches-widget.dart`
- [ ] Connect search tab route `/search` → `SearchScreen`
- [ ] Run `build_runner` cho generated providers
- [ ] Test: gõ query → results hiện sau 300ms
- [ ] Test: highlight đúng text match
- [ ] Test: filter by folder → chỉ hiện notes trong folder đó
- [ ] Test: filter by tag → đúng kết quả
- [ ] Test: recent searches persist sau hot restart
- [ ] Test: empty state message đúng

## Success Criteria

- Tìm "flutter" trong 100 notes < 100ms
- Highlight hiển thị đúng matched text
- Filter chips stack (có thể chọn folder + pinned cùng lúc)
- Recent searches lưu persistent qua app restart
- Empty state rõ ràng khi không có kết quả

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Isar fullText search không match partial words | Medium | Test với `Contains` fallback nếu fullText thiếu |
| Snippet extraction khi match ở cuối string | Low | Sử dụng `.clamp(0, length)` |
| SearchFilters provider reset khi navigate | Low | Keep provider alive hoặc dùng `keepAlive` |

## Next Steps

→ Phase 6: UI Polish, Theme & Testing
