import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category { work, personal, study, other }

class Task {
  Task({
    String? id,
    required this.title,
    required this.note,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String note;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
