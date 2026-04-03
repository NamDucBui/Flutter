import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/tag-entity.dart';
import '../../data/tag-repository-impl.dart';
import '../providers/tags-provider.dart';
import 'tag-chip-widget.dart';

/// Bottom sheet for assigning/removing tags on a note.
class TagPickerBottomSheetWidget extends ConsumerWidget {
  final String noteId;

  const TagPickerBottomSheetWidget({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsListProvider);
    final selectedTags = ref.watch(noteTagsEditorProvider(noteId));
    final editorNotifier = ref.read(noteTagsEditorProvider(noteId).notifier);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      builder: (_, controller) => Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tags',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton.icon(
                  onPressed: () => _createTag(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('New Tag'),
                ),
              ],
            ),
          ),
          Expanded(
            child: tagsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (tags) => tags.isEmpty
                  ? const Center(child: Text('No tags yet'))
                  : ListView.builder(
                      controller: controller,
                      itemCount: tags.length,
                      itemBuilder: (_, i) {
                        final tag = tags[i];
                        final isSelected = selectedTags.contains(tag.id);
                        return CheckboxListTile(
                          value: isSelected,
                          title: TagChipWidget(tag: tag),
                          onChanged: (_) =>
                              editorNotifier.toggleTag(tag.id, noteId),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _createTag(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Tag'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tag name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              await ref.read(tagRepositoryProvider).createTag(TagEntity(
                    id: const Uuid().v4(),
                    name: name,
                    color: '#607D8B',
                  ));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
