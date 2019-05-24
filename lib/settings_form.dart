import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class SettingsForm extends StatefulWidget {
  @override
  SettingsFormState createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  bool _isEnabled = false;
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        _isEnabled = prefs.getBool('_isEnabled') ?? false;
        int hour = prefs.getInt('hour');
        int minute = prefs.getInt('minute');
        if (hour != null && minute != null) {
          _time = TimeOfDay(hour: hour, minute: minute);
        }
      });
    });
  }

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
                    SharedPreferences.getInstance()
                        .then((SharedPreferences prefs) {
                      prefs.setBool('_isEnabled', _isEnabled);
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
                        SharedPreferences.getInstance()
                            .then((SharedPreferences prefs) {
                          prefs.setInt('hour', value.hour);
                          prefs.setInt('minute', value.minute);
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
