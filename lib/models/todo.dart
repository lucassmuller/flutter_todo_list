import 'package:flutter/material.dart';

class Todo {
  int _id;
  String _title = '';
  String _description = '';
  TodoPriority _priority = TodoPriority.low;
  DateTime _date;

  Todo(this._title, this._priority, this._date, [this._description]);
  Todo.empty();

  int get id => _id;
  String get title => _title;
  String get description => _description;
  TodoPriority get priority => _priority;
  DateTime get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(TodoPriority newPriority) {
    _priority = newPriority;
  }

  set date(DateTime newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date.toString();
    map['priority'] = _priority.id;
    if (_id != null) map['id'] = _id;
    return map;
  }

  Todo.fromObject(dynamic o) {
    if (o == null) return;
    this._id = o['id'];
    this._title = o['title'];
    this._description = o['description'];
    this._priority = TodoPriority.fromId(o['priority']);
    this._date = DateTime.parse(o['date']);
  }
}

class TodoPriority {
  static final high = const TodoPriority(1, 'High', Colors.red);
  static final medium = const TodoPriority(2, 'Medium', Colors.orange);
  static final low = const TodoPriority(3, 'Low', Colors.green);
  static final values = [high, medium, low];

  final int id;
  final String text;
  final Color color;
  const TodoPriority(this.id, this.text, this.color);

  static TodoPriority fromId(int id) => values.firstWhere((e) => e.id == id);
}
