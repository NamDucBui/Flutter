import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';

class NewTask extends StatefulWidget {
  const NewTask({
    super.key,
    this.task,
    required this.onAddTask,
    this.onEditTask,
  });

  final Task? task;
  final void Function(Task task) onAddTask;
  final void Function(Task task)? onEditTask;
  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.study;

  bool _isChange = false;

  String _initTitle = '';
  String _initNote = '';
  // DateTime? _initDate;
  // Category _initCategory = Category.study;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: lastDate,
    );
    if (pickedDate == null) return;
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _checkChange() {
    final titleNow = _titleController.text.trim();
    final noteNow = _noteController.text.trim();
    final change = titleNow != _initTitle.trim() || noteNow != _initNote.trim();

    if (change != _isChange) {
      setState(() {
        _isChange = change;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _noteController.text = widget.task!.note;
      _selectedDate = widget.task!.date;
      _selectedCategory = widget.task!.category;

      _initTitle = widget.task!.title;
      _initNote = widget.task!.note;
      // _initDate = widget.task!.date;
      // _initCategory = widget.task!.category;
    }

    _titleController.addListener(_checkChange);
  }

  void _submitTask() {
    if (_titleController.text.trim().isEmpty ||
        _noteController.text.trim().isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Make sure a valid was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }
    if (widget.task == null) {
      widget.onAddTask(
        Task(
          title: _titleController.text,
          note: _noteController.text,
          date: _selectedDate!,
          category: _selectedCategory,
        ),
      );
    } else {
      widget.onEditTask?.call(
        Task(
          id: widget.task?.id,
          title: _titleController.text,
          note: _noteController.text,
          date: _selectedDate!,
          category: _selectedCategory,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = widget.task == null ? true : _isChange;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  maxLength: 50,
                  decoration: InputDecoration(label: Text('Note')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No selected date'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: canSave ? _submitTask : null,
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
