import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

int day = 86400000;

class Task {
  Task({this.name});

  Task.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    final List<dynamic> decodedHistory = json['_histories'];
    _histories = decodedHistory.cast<int>();
  }
  String name = '';
  List<int> _histories = <int>[];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        '_histories': _histories,
      };

  static Future<File> _localFile() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    return File('$path/tasks.json');
  }

  static Future<void> save(List<Task> tasks) async {
    final File file = await _localFile();
    file.writeAsString(json.encode(tasks));
  }

  static Future<List<Task>> load() async {
    final File file = await _localFile();
    if (file.existsSync()) {
      final List<dynamic> decoded = json.decode(await file.readAsString());
      return decoded.map((dynamic json) => Task.fromJson(json)).toList();
    } else {
      return <Task>[];
    }
  }

  int _beginningOfDay() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  }

  int _yesterday() {
    return _beginningOfDay() - day;
  }

  int _today() {
    return _beginningOfDay();
  }

  bool didYesterday() {
    return _did(_yesterday());
  }

  bool didToday() {
    return _did(_today());
  }

  bool _did(int date) {
    return _histories.contains(date);
  }

  void toggleYesterday() {
    _toggle(_yesterday());
  }

  void toggleToday() {
    _toggle(_today());
  }

  void _toggle(int date) {
    if (_did(date)) {
      _histories.remove(date);
    } else {
      _histories.add(date);
    }
    _histories.sort();
  }

  int streaks() {
    int count = 0;
    for (int i = 0; i < _histories.length; i++) {
      if (_histories[_histories.length - 1 - i] != _today() - day * i) {
        break;
      }
      count++;
    }
    return count;
  }
}
