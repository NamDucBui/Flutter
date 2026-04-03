import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/folder-entity.dart';
import '../../data/folder-repository-impl.dart';
import '../providers/folders-provider.dart';
import 'folder-create-dialog-widget.dart';

/// Folder row with note count badge and long-press context menu.
class FolderListTileWidget extends ConsumerWidget {
  final FolderEntity folder;
  final bool isSelected;
  final VoidCallback onTap;

  const FolderListTileWidget({
    super.key,
    required this.folder,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(folderNoteCountProvider(folder.id));

    return ListTile(
      selected: isSelected,
      leading: Text(folder.icon, style: const TextStyle(fontSize: 22)),
      title: Text(folder.name),
      trailing: countAsync.when(
        data: (n) => n > 0
            ? Chip(
                label: Text('$n'),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
      onTap: onTap,
      onLongPress: () => _showMenu(context, ref),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) =>
                      FolderCreateDialogWidget(existingFolder: folder),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error),
              title: const Text('Delete folder'),
              onTap: () async {
                Navigator.pop(context);
                await ref
                    .read(folderRepositoryProvider)
                    .deleteFolder(folder.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
