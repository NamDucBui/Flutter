import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin that adds a 5-second undo-delete snackbar to any [ConsumerStatefulWidget].
///
/// Usage:
/// ```dart
/// class _MyScreenState extends ConsumerState<MyScreen> with UndoDeleteMixin {
///   void _handleDelete(String id) async {
///     await ref.read(repo).deleteNote(id);
///     showUndoDeleteSnackbar(
///       message: 'Note deleted',
///       onUndo: () => ref.read(repo).restoreNote(id),
///     );
///   }
/// }
/// ```
mixin UndoDeleteMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showUndoDeleteSnackbar({
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: SnackBarAction(label: 'Undo', onPressed: onUndo),
      ),
    );
  }
}
