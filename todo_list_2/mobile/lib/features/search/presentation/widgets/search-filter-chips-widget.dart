import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../folders/domain/folder-entity.dart';
import '../../../folders/presentation/providers/folders-provider.dart';
import '../../../tags/domain/tag-entity.dart';
import '../../../tags/presentation/providers/tags-provider.dart';
import '../../../tags/presentation/widgets/tag-chip-widget.dart';
import '../providers/search-filters-provider.dart';

/// Horizontal filter chips for folder, tag, and pinned filtering.
class SearchFilterChipsWidget extends ConsumerWidget {
  const SearchFilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);
    final folders = ref.watch(foldersListProvider).value ?? [];
    final tags = ref.watch(tagsListProvider).value ?? [];

    if (!filters.hasActiveFilters && folders.isEmpty && tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          if (filters.hasActiveFilters) ...[
            ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.close, size: 14),
              onPressed: notifier.clearAll,
            ),
            const SizedBox(width: 6),
          ],
          FilterChip(
            label: const Text('Pinned'),
            selected: filters.pinnedOnly,
            onSelected: (_) => notifier.togglePinned(),
          ),
          if (folders.isNotEmpty) ...[
            const SizedBox(width: 6),
            ChoiceChip(
              label: Text(filters.folderId != null
                  ? (folders
                          .where((f) => f.id == filters.folderId)
                          .firstOrNull
                          ?.name ??
                      'Folder')
                  : 'Folder'),
              selected: filters.folderId != null,
              onSelected: (_) => _showFolderPicker(context, ref, folders),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(width: 6),
            ChoiceChip(
              label: Text(filters.tagId != null
                  ? '#${tags.where((t) => t.id == filters.tagId).firstOrNull?.name ?? 'Tag'}'
                  : 'Tag'),
              selected: filters.tagId != null,
              onSelected: (_) => _showTagPicker(context, ref, tags),
            ),
          ],
        ],
      ),
    );
  }

  void _showFolderPicker(
      BuildContext ctx, WidgetRef ref, List<FolderEntity> folders) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('All Folders'),
            onTap: () {
              ref.read(searchFiltersProvider.notifier).setFolder(null);
              Navigator.pop(ctx);
            },
          ),
          ...folders.map((f) => ListTile(
                leading: Text(f.icon),
                title: Text(f.name),
                onTap: () {
                  ref
                      .read(searchFiltersProvider.notifier)
                      .setFolder(f.id);
                  Navigator.pop(ctx);
                },
              )),
        ],
      ),
    );
  }

  void _showTagPicker(
      BuildContext ctx, WidgetRef ref, List<TagEntity> tags) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('All Tags'),
            onTap: () {
              ref.read(searchFiltersProvider.notifier).setTag(null);
              Navigator.pop(ctx);
            },
          ),
          ...tags.map((t) => ListTile(
                leading: TagChipWidget(tag: t),
                onTap: () {
                  ref
                      .read(searchFiltersProvider.notifier)
                      .setTag(t.id);
                  Navigator.pop(ctx);
                },
              )),
        ],
      ),
    );
  }
}
