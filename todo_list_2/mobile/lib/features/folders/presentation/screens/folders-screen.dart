import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty-state-widget.dart';
import '../providers/folders-provider.dart';
import '../widgets/folder-list-tile-widget.dart';
import '../widgets/folder-create-dialog-widget.dart';

/// Screen listing all folders with note counts.
class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersListProvider);
    final selectedFolder = ref.watch(selectedFolderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: foldersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (folders) {
          if (folders.isEmpty) {
            return const EmptyStateWidget(
              emoji: '📁',
              title: 'No Folders',
              subtitle: 'Tap + to create a folder',
            );
          }
          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (_, i) => FolderListTileWidget(
              folder: folders[i],
              isSelected: selectedFolder == folders[i].id,
              onTap: () => ref
                  .read(selectedFolderProvider.notifier)
                  .select(folders[i].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const FolderCreateDialogWidget(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
