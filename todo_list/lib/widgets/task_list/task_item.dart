import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key, this.onEdit});

  final Task task;

  final void Function(Task task)? onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onEdit?.call(task);
      },
      child: Card(
        color: task.category == Category.work ? Colors.red : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(task.title),
                  const Spacer(),
                  Text(task.formattedDate),
                ],
              ),
              Row(
                children: [
                  Text(task.note),
                  Text(' - '),
                  Text(task.category.name),
                ],
              ),
              // Text(task.title),
              // Text(task.note),
              // const SizedBox(height: 4),
              // Row(
              //   children: [
              //     Text(task.title),
              //     const Spacer(),
              //     Text(task.note),
              //     const Spacer(),
              //     Text(task.category.name),
              //     const Spacer(),
              //     Text(task.formattedDate),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
