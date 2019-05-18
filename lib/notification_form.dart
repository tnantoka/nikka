import 'package:flutter/material.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class NotificationForm extends StatefulWidget {
  @override
  NotificationFormState createState() => NotificationFormState();
}

class NotificationFormState extends State<NotificationForm> {
  bool _isEnabled = false;
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Enabled', style: theme.textTheme.subtitle),
                Switch.adaptive(
                  value: _isEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isEnabled = !_isEnabled;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Time', style: theme.textTheme.subtitle),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: _time,
                      ).then<void>((TimeOfDay value) {
                        setState(() {
                          _time = value;
                        });
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Text('${_time.format(context)}'),
                        const Icon(Icons.arrow_drop_down,
                            color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
