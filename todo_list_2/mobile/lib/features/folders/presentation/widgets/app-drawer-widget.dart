import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/folders-provider.dart';
import 'folder-list-tile-widget.dart';
import 'folder-create-dialog-widget.dart';

/// Navigation drawer with All Notes, Folders, and Recently Deleted.
class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersListProvider);
    final selectedFolder = ref.watch(selectedFolderProvider);

    return NavigationDrawer(
      onDestinationSelected: (_) {},
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Notes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        // All Notes
        ListTile(
          selected: selectedFolder == null,
          leading: const Icon(Icons.notes_outlined),
          title: const Text('All Notes'),
          onTap: () {
            ref.read(selectedFolderProvider.notifier).select(null);
            Navigator.pop(context);
          },
        ),
        const Divider(indent: 16, endIndent: 16),
        // Folders section header
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 4, 16, 0),
          child: Text(
            'FOLDERS',
            style: TextStyle(fontSize: 11, letterSpacing: 1),
          ),
        ),
        // Folder list
        ...?foldersAsync.value?.map(
          (f) => FolderListTileWidget(
            folder: f,
            isSelected: selectedFolder == f.id,
            onTap: () {
              ref.read(selectedFolderProvider.notifier).select(f.id);
              Navigator.pop(context);
            },
          ),
        ),
        // New folder button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const FolderCreateDialogWidget(),
            ),
            icon: const Icon(Icons.create_new_folder_outlined),
            label: const Text('New Folder'),
          ),
        ),
        const Divider(indent: 16, endIndent: 16),
        // Recently Deleted
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Recently Deleted'),
          onTap: () {
            Navigator.pop(context);
            context.push('/recently-deleted');
          },
        ),
      ],
    );
  }
}
