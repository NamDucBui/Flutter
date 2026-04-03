import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/note-entity.dart';
import 'note-color-picker-widget.dart';

/// Grid-view note card; long-press triggers delete confirmation.
class NoteGridCardWidget extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteGridCardWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color == '#FFFFFF' ? null : hexToColor(note.color),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _confirmDelete(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 12),
                ],
              ),
              if (note.plainContent.isNotEmpty) ...[
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    note.plainContent,
                    maxLines: 6,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                DateFormat.MMMd().format(note.updatedAt),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This note will be moved to trash.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }
}
