import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/folder-entity.dart';
import '../../data/folder-repository-impl.dart';

/// Dialog for creating a new folder or renaming an existing one.
class FolderCreateDialogWidget extends ConsumerStatefulWidget {
  final FolderEntity? existingFolder;

  const FolderCreateDialogWidget({super.key, this.existingFolder});

  @override
  ConsumerState<FolderCreateDialogWidget> createState() =>
      _FolderCreateDialogWidgetState();
}

class _FolderCreateDialogWidgetState
    extends ConsumerState<FolderCreateDialogWidget> {
  late final TextEditingController _nameCtrl;
  String _icon = '📁';

  static const _icons = [
    '📁', '📔', '📚', '🏠', '💼', '🎨', '🔬', '💡', '✈️', '🎵',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingFolder?.name ?? '');
    _icon = widget.existingFolder?.icon ?? '📁';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(folderRepositoryProvider);
    if (widget.existingFolder == null) {
      await repo.createFolder(FolderEntity(
        id: const Uuid().v4(),
        name: name,
        icon: _icon,
        color: '#607D8B',
        createdAt: DateTime.now(),
      ));
    } else {
      await repo.updateFolder(
        widget.existingFolder!.copyWith(name: name, icon: _icon),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingFolder != null;
    return AlertDialog(
      title: Text(isEdit ? 'Rename Folder' : 'New Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Folder name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _icons
                  .map((icon) => GestureDetector(
                        onTap: () => setState(() => _icon = icon),
                        child: Container(
                          width: 44,
                          height: 44,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: _icon == icon
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(icon,
                                style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
