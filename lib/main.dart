import 'package:flutter/material.dart';

import 'notification_form.dart';
import 'task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nikka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Nikka'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<Task> _tasks = <Task>[];

  void _addNewTask() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new task'),
          content: TextField(
            controller: _textController,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  final Task task = Task(name: _textController.text);
                  _tasks.insert(0, task);
                });
                Navigator.of(context).pop();
                _textController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Notifications',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => NotificationForm(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final Task task = _tasks[index];
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_tasks[index].name, style: textTheme.title),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Yesterday'),
                      onPressed: () {
                        setState(() {
                          task.didYesterday = !task.didYesterday;
                          task.days = (task.didYesterday ? 1 : 0) +
                              (task.didToday ? 1 : 0);
                        });
                      },
                      color: task.didYesterday
                          ? Colors.green[300]
                          : Colors.grey[300],
                    ),
                    const SizedBox(width: 8.0),
                    FlatButton(
                      child: const Text('Today'),
                      onPressed: () {
                        setState(() {
                          task.didToday = !task.didToday;
                          task.days = (task.didYesterday ? 1 : 0) +
                              (task.didToday ? 1 : 0);
                        });
                      },
                      color:
                          task.didToday ? Colors.green[300] : Colors.grey[300],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text('${_tasks[index].days} days',
                            style: textTheme.subtitle),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
