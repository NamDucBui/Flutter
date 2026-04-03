import 'package:flutter/material.dart';

/// AppBar for the notes list screen with grid/list view toggle action.
class NotesAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isGridView;
  final VoidCallback onToggleView;

  const NotesAppBarWidget({
    super.key,
    required this.title,
    required this.isGridView,
    required this.onToggleView,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(isGridView ? Icons.view_list_outlined : Icons.grid_view),
          tooltip: isGridView ? 'List view' : 'Grid view',
          onPressed: onToggleView,
        ),
      ],
    );
  }
}
