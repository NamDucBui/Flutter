import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/widgets/new_task.dart';
import 'package:todo_list/widgets/task_list/task_list.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  Category? _filterCategory;
  final List<Task> _registeredTasks = [
    Task(
      title: 'aaa',
      note: 'a a a',
      date: DateTime(2026, 1, 11),
      category: Category.work,
    ),
    Task(
      title: 'bbb',
      note: 'b b b',
      date: DateTime(2026, 1, 12),
      category: Category.study,
    ),
  ];

  String _searchQuery = '';

  void _openAddTask() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  void _addTask(Task task) {
    setState(() {
      _registeredTasks.add(task);
    });
  }

  void _removeTask(Task task) {
    setState(() {
      _registeredTasks.remove(task);
    });
  }

  void _updateTask(Task updatedTask) {
    final index = _registeredTasks.indexWhere((t) => t.id == updatedTask.id);
    if (index == -1) return;
    setState(() {
      _registeredTasks[index] = updatedTask;
    });
  }

  void _openEditTask(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) =>
          NewTask(onAddTask: _addTask, task: task, onEditTask: _updateTask),
    );
  }

  void _reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _registeredTasks.removeAt(oldIndex);
      _registeredTasks.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(child: Text('No data'));

    final q = _searchQuery.trim().toLowerCase();

    final filteredTasks = _registeredTasks.where((t) {
      final matchesCategory =
          _filterCategory == null || t.category == _filterCategory;
      final title = t.title.toLowerCase();
      final note = t.note.toLowerCase();
      final matchesSearch = q.isEmpty || title.contains(q) || note.contains(q);
      return matchesCategory && matchesSearch;
    }).toList();

    final reorderEnabled = q.isEmpty && _filterCategory == null;
    if (filteredTasks.isNotEmpty) {
      mainContent = TaskList(
        tasks: filteredTasks,
        onRemoveTask: _removeTask,
        onEditTasks: _openEditTask,
        onReorderTasks: _reorderTasks,
        reoderEnabled: reorderEnabled,
      );
    }

    // if (_registeredTasks.isNotEmpty) {
    //   mainContent = TaskList(
    //     tasks: filteredTasks,
    //     onRemoveTask: _removeTask,
    //     onEditTasks: _openEditTask,
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _openAddTask, icon: Icon(Icons.add))],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Tim theo title/ note...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          DropdownButton(
            value: _filterCategory,
            hint: Text("All"),
            items: [
              const DropdownMenuItem<Category?>(
                value: null,
                child: Text("All"),
              ),
              ...Category.values.map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name.toString()),
                ),
              ),
            ].toList(),
            onChanged: (value) {
              if (value == null) {
                _filterCategory = null;
              }
              setState(() {
                _filterCategory = value;
              });
            },
          ),
          Text('Todo List'),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
