import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search-provider.dart';

/// Shows recent search suggestions when query is empty.
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
              child: Text(
                'Recent',
                style: Theme.of(context).textTheme.labelSmall,
              ),
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
