import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        _isEnabled = prefs.getBool('_isEnabled') ?? false;
        final int hour = prefs.getInt('hour');
        final int minute = prefs.getInt('minute');
        if (hour != null && minute != null) {
          _time = TimeOfDay(hour: hour, minute: minute);
        }
      });
    });

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _updateNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    if (!_isEnabled) {
      return;
    }

    final Time time = Time(_time.hour, _time.minute, 0);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('reminder', 'Reminder', 'Daily reminder');
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Reminder',
        "Today's TODOs is over?", time, platformChannelSpecifics);
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
                    _updateNotification();
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
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _time = value;
                        });
                        SharedPreferences.getInstance()
                            .then((SharedPreferences prefs) {
                          prefs.setInt('hour', value.hour);
                          prefs.setInt('minute', value.minute);
                        });
                        _updateNotification();
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
