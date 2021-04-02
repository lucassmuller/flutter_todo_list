import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/utils/db_helper.dart';

class TodoDetails extends StatefulWidget {
  final Todo _todo;
  TodoDetails(this._todo);

  @override
  State<StatefulWidget> createState() => _TodoDetailsState(this._todo);
}

class _TodoDetailsAction {
  final String name;
  final void Function(BuildContext context, Todo todo) perform;

  const _TodoDetailsAction(this.name, this.perform);
}

final dbHelper = DbHelper();
final actions = <_TodoDetailsAction>[
  _TodoDetailsAction('Save', (context, todo) async {
    final showSnackBar = (String text) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));

    todo.date = DateTime.now();
    if (todo.id == null) {
      await dbHelper.insertTodo(todo);
      showSnackBar('Todo successfully created!');
    } else {
      await dbHelper.updateTodo(todo);
      showSnackBar('Todo successfully updated!');
    }

    Navigator.pop(context, true);
  }),
  _TodoDetailsAction('Delete', (context, todo) async {
    if (todo.id != null) {
      final result = await dbHelper.deleteTodo(todo.id);
      final snackBarText = result == 0
          ? 'Error deleting the todo.'
          : 'Todo successfully deleted!';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(snackBarText)));
    }

    Navigator.pop(context, true);
  }),
];

class _TodoDetailsState extends State<TodoDetails> {
  final Todo _todo;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _priority;

  _TodoDetailsState(this._todo);

  @override
  void initState() {
    _titleController.text = _todo.title;
    _descriptionController.text = _todo.description;
    _priority = _todo.priority.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        title: Text(_todo.id == null ? 'New todo' : 'Edit todo'),
        actions: [
          PopupMenuButton(
            onSelected: (_TodoDetailsAction action) {
              action.perform(context, widget._todo);
            },
            itemBuilder: (context) => actions
                .map((action) => PopupMenuItem(
                      value: action,
                      child: Text(action.name),
                    ))
                .toList(),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                buildTextField(
                  label: 'Title',
                  style: textStyle,
                  controller: _titleController,
                  onChanged: (_) => updateTitle(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: buildTextField(
                    label: 'Description',
                    style: textStyle,
                    controller: _descriptionController,
                    onChanged: (_) => updateDescription(),
                  ),
                ),
                DropdownButtonFormField(
                  style: textStyle,
                  value: _priority,
                  onChanged: updatePriority,
                  items: TodoPriority.values
                      .map((priority) => DropdownMenuItem(
                            value: priority.id,
                            child: Text(priority.text),
                          ))
                      .toList(),
                  decoration: buildInputDecoration(
                    label: 'Priority',
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildTextField({
    String label,
    TextStyle style,
    TextEditingController controller,
    void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: style,
      onChanged: onChanged,
      decoration: buildInputDecoration(label: label, style: style),
    );
  }

  InputDecoration buildInputDecoration({
    String label,
    TextStyle style,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: style,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  void updateTitle() {
    _todo.title = _titleController.text;
  }

  void updateDescription() {
    _todo.description = _descriptionController.text;
  }

  void updatePriority(int value) {
    _todo.priority = TodoPriority.fromId(value);
    setState(() {
      _priority = value;
    });
  }
}
