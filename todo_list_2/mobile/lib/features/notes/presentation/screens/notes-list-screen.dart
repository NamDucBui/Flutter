import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/empty-state-widget.dart';
import '../../../../shared/widgets/undo-delete-mixin.dart';
import '../../domain/note-entity.dart';
import '../../data/note-repository-impl.dart';
import '../providers/notes-list-provider.dart';
import '../widgets/note-card-widget.dart';
import '../widgets/note-grid-card-widget.dart';
import '../widgets/notes-app-bar-widget.dart';
import '../../../folders/presentation/widgets/app-drawer-widget.dart';
import '../../../folders/presentation/providers/folders-provider.dart';

/// Main notes list screen with list/grid toggle and FAB to create notes.
class NotesListScreen extends ConsumerStatefulWidget {
  final String? folderId;

  const NotesListScreen({super.key, this.folderId});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen>
    with UndoDeleteMixin {
  bool _isGridView = false;

  Future<void> _deleteNote(String id) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.deleteNote(id);
    if (!mounted) return;
    showUndoDeleteSnackbar(
      message: 'Note deleted',
      onUndo: () => repo.restoreNote(id),
    );
  }

  void _openNote(String id) => context.push('/notes/$id');
  void _newNote() => context.push('/notes/create');

  @override
  Widget build(BuildContext context) {
    // Use selectedFolderProvider if no explicit folderId passed via constructor
    final activeFolderId =
        widget.folderId ?? ref.watch(selectedFolderProvider);
    final notesAsync = ref.watch(
      pinnedAndNotesProvider(folderId: activeFolderId),
    );

    return Scaffold(
      drawer: const AppDrawerWidget(),
      appBar: NotesAppBarWidget(
        title: 'Notes',
        isGridView: _isGridView,
        onToggleView: () => setState(() => _isGridView = !_isGridView),
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final (pinned, regular) = data;
          if (pinned.isEmpty && regular.isEmpty) {
            return const EmptyStateWidget(type: EmptyStateType.allNotes);
          }
          return _isGridView
              ? _GridNotes(
                  pinned: pinned,
                  regular: regular,
                  onTap: _openNote,
                  onDelete: _deleteNote,
                )
              : _ListNotes(
                  pinned: pinned,
                  regular: regular,
                  onTap: _openNote,
                  onDelete: _deleteNote,
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newNote,
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private list layout
// ---------------------------------------------------------------------------

class _ListNotes extends StatelessWidget {
  final List<NoteEntity> pinned;
  final List<NoteEntity> regular;
  final void Function(String) onTap;
  final void Function(String) onDelete;

  const _ListNotes({
    required this.pinned,
    required this.regular,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (pinned.isNotEmpty) ...[
          const _SectionHeader('Pinned'),
          ...pinned.map((n) => NoteCardWidget(
                note: n,
                onTap: () => onTap(n.id),
                onDelete: () => onDelete(n.id),
              )),
          const _SectionHeader('Notes'),
        ],
        ...regular.map((n) => NoteCardWidget(
              note: n,
              onTap: () => onTap(n.id),
              onDelete: () => onDelete(n.id),
            )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private grid layout
// ---------------------------------------------------------------------------

class _GridNotes extends StatelessWidget {
  final List<NoteEntity> pinned;
  final List<NoteEntity> regular;
  final void Function(String) onTap;
  final void Function(String) onDelete;

  const _GridNotes({
    required this.pinned,
    required this.regular,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final all = [...pinned, ...regular];
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: all.length,
      itemBuilder: (_, i) => NoteGridCardWidget(
        note: all[i],
        onTap: () => onTap(all[i].id),
        onDelete: () => onDelete(all[i].id),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8),
      ),
    );
  }
}
