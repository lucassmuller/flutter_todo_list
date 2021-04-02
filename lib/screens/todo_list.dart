import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/utils/db_helper.dart';
import 'package:todo_list/screens/todo_details.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _dbHelper = DbHelper();
  List<Todo> _todos;
  var _todosCount = 0;

  @override
  Widget build(BuildContext context) {
    if (_todos == null) {
      _todos = [];
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(Todo.empty());
        },
        tooltip: 'Add new todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: _todosCount,
      itemBuilder: (BuildContext context, int position) {
        final todo = _todos[position];
        return Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
            title: Text(todo.title),
            subtitle: Text(DateFormat.yMd().format(todo.date)),
            leading: CircleAvatar(
              backgroundColor: todo.priority.color,
              child: Text(
                todo.priority.id.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              navigateToDetails(todo);
            },
          ),
        );
      },
    );
  }

  void getData() async {
    final todos = await _dbHelper.getTodos();

    setState(() {
      _todos = todos;
      _todosCount = todos.length;
    });
  }

  void navigateToDetails(Todo todo) async {
    final bool refreshData = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetails(todo)));

    if (refreshData == true) {
      getData();
    }
  }
}
