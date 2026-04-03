import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search-provider.dart';
import '../widgets/search-result-card-widget.dart';
import '../widgets/search-filter-chips-widget.dart';
import '../widgets/recent-searches-widget.dart';

/// Full-text search screen with debounce, filters, and highlights.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: SearchBar(
              controller: _textCtrl,
              hintText: 'Search notes…',
              leading: const Icon(Icons.search),
              trailing: [
                if (query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _textCtrl.clear();
                      ref.read(searchQueryProvider.notifier).clear();
                    },
                  ),
              ],
              onChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).update(q),
            ),
          ),
          const SliverToBoxAdapter(
            child: SearchFilterChipsWidget(),
          ),
          if (query.isNotEmpty)
            SliverToBoxAdapter(
              child: resultsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (r) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    '${r.length} note${r.length == 1 ? '' : 's'} found',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          if (query.isEmpty)
            SliverToBoxAdapter(
              child: RecentSearchesWidget(
                onTap: (q) {
                  _textCtrl.text = q;
                  ref.read(searchQueryProvider.notifier).update(q);
                },
              ),
            )
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
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔍',
                                style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text('No results for "$query"'),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => SearchResultCardWidget(
                          note: results[i],
                          query: query,
                          onTap: () =>
                              context.push('/notes/${results[i].id}'),
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
