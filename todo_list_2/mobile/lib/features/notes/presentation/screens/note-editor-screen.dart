import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../providers/note-editor-provider.dart';
import '../widgets/note-color-picker-widget.dart';

/// Rich text note editor screen with auto-save, pin, and color picker.
class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _noteBackground(String? hex) {
    if (hex == null || hex == '#FFFFFF') return Colors.white;
    return hexToColor(hex);
  }

  void _showColorPicker(BuildContext context) {
    final notifier = ref.read(noteEditorProvider(widget.noteId).notifier);
    final currentColor =
        ref.read(noteEditorProvider(widget.noteId)).value?.color ?? '#FFFFFF';

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Note Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            NoteColorPickerWidget(
              selectedColor: currentColor,
              onColorSelected: (c) {
                notifier.setColor(c);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorAsync = ref.watch(noteEditorProvider(widget.noteId));
    final notifier = ref.read(noteEditorProvider(widget.noteId).notifier);
    final bgColor = _noteBackground(editorAsync.value?.color);
    final isPinned = editorAsync.value?.isPinned ?? false;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: notifier.togglePin,
            tooltip: isPinned ? 'Unpin note' : 'Pin note',
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showColorPicker(context),
            tooltip: 'Note color',
          ),
        ],
      ),
      body: editorAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => notifier.controller == null
            ? const Center(child: CircularProgressIndicator())
            : _EditorBody(
                notifier: notifier,
                focusNode: _focusNode,
                scrollController: _scrollController,
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Editor body — separated to avoid rebuilds when async state changes
// ---------------------------------------------------------------------------

class _EditorBody extends StatelessWidget {
  final NoteEditor notifier;
  final FocusNode focusNode;
  final ScrollController scrollController;

  const _EditorBody({
    required this.notifier,
    required this.focusNode,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillSimpleToolbar(
          controller: notifier.controller!,
          config: const QuillSimpleToolbarConfig(
            showFontFamily: false,
            showFontSize: false,
            showInlineCode: true,
            showCodeBlock: false,
            showSubscript: false,
            showSuperscript: false,
            showDirection: false,
            showSearchButton: false,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: QuillEditor(
            controller: notifier.controller!,
            focusNode: focusNode,
            scrollController: scrollController,
            config: const QuillEditorConfig(
              padding: EdgeInsets.all(16),
              placeholder: 'Start writing...',
              autoFocus: true,
            ),
          ),
        ),
      ],
    );
  }
}
