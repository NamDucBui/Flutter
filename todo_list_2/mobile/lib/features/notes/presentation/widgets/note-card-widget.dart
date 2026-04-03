import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/note-entity.dart';
import 'note-color-picker-widget.dart';

/// List-view note card with swipe-to-delete support.
class NoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await _confirmDelete(context);
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        color: note.color == '#FFFFFF' ? null : hexToColor(note.color),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                      const Icon(Icons.push_pin, size: 14),
                  ],
                ),
                if (note.plainContent.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    note.plainContent,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  _formatDate(note.updatedAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
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
    return result ?? false;
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat.jm().format(dt);
    if (diff.inDays < 7) return DateFormat.E().format(dt);
    return DateFormat.MMMd().format(dt);
  }
}
