import 'package:flutter/material.dart';

/// Contextual variants for the empty state display.
enum EmptyStateType { allNotes, folder, search, recentlyDeleted }

/// Full-screen empty state with emoji, title, and subtitle.
///
/// Pass [type] for context-aware defaults, or override individual
/// [emoji] / [title] / [subtitle] fields for custom messages.
class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? emoji;
  final String? title;
  final String? subtitle;

  const EmptyStateWidget({
    super.key,
    this.type = EmptyStateType.allNotes,
    this.emoji,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final (e, t, s) = _resolveContent();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(e, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              t,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (String, String, String) _resolveContent() {
    // Prefer explicit overrides, then fall back to type-based defaults.
    final defaults = _defaultsFor(type);
    return (
      emoji ?? defaults.$1,
      title ?? defaults.$2,
      subtitle ?? defaults.$3,
    );
  }

  static (String, String, String) _defaultsFor(EmptyStateType type) =>
      switch (type) {
        EmptyStateType.allNotes => (
            '📝',
            'No Notes Yet',
            'Tap + to create your first note',
          ),
        EmptyStateType.folder => (
            '📁',
            'Empty Folder',
            'Move notes here from All Notes',
          ),
        EmptyStateType.search => (
            '🔍',
            'No Results',
            'Try different keywords or remove filters',
          ),
        EmptyStateType.recentlyDeleted => (
            '🗑️',
            'Nothing Here',
            'Deleted notes appear here for 30 days',
          ),
      };
}
