import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/widgets/task_list/task_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.onRemoveTask,
    required this.onEditTasks,
    required this.onReorderTasks,
    required this.reoderEnabled,
  });
  final List<Task> tasks;

  final void Function(Task task) onRemoveTask;
  final void Function(Task task)? onEditTasks;
  final void Function(int oldIndex, int newIndex) onReorderTasks;
  final bool reoderEnabled;
  @override
  Widget build(BuildContext context) {
    if (!reoderEnabled) {
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            child: TaskItem(task, onEdit: onEditTasks),
            onDismissed: (_) => onRemoveTask(task),
          );
        },
      );
    }
    return ReorderableListView.builder(
      itemCount: tasks.length,
      onReorder: onReorderTasks,
      buildDefaultDragHandles: true,
      itemBuilder: (ctx, index) {
        final task = tasks[index];

        return Dismissible(
          key: ValueKey(task.id),
          child: TaskItem(task, onEdit: onEditTasks),
          onDismissed: (_) => onRemoveTask(task),
        );
      },
    );
  }
}
