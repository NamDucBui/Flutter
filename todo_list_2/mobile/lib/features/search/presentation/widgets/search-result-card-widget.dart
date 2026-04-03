import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../notes/domain/note-entity.dart';
import 'search-highlight-text-widget.dart';

/// Search result card showing title, content snippet, and date.
class SearchResultCardWidget extends StatelessWidget {
  final NoteEntity note;
  final String query;
  final VoidCallback onTap;

  const SearchResultCardWidget({
    super.key,
    required this.note,
    required this.query,
    required this.onTap,
  });

  String _snippet() {
    final lower = note.plainContent.toLowerCase();
    final idx = lower.indexOf(query.toLowerCase());
    if (idx == -1) {
      return note.plainContent.substring(
          0, note.plainContent.length.clamp(0, 150));
    }
    final start = (idx - 60).clamp(0, note.plainContent.length);
    final end = (idx + 120).clamp(0, note.plainContent.length);
    return '${start > 0 ? '…' : ''}${note.plainContent.substring(start, end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchHighlightTextWidget(
                text: note.title.isEmpty ? 'Untitled' : note.title,
                query: query,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (note.plainContent.isNotEmpty) ...[
                const SizedBox(height: 4),
                SearchHighlightTextWidget(
                  text: _snippet(),
                  query: query,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 6),
              Text(
                DateFormat('MMM d, y').format(note.updatedAt),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
