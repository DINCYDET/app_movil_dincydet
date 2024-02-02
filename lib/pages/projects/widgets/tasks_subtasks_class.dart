import 'package:flutter/material.dart';

class BaseData {
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController supername = TextEditingController();
  int superid = -1;
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();

  bool isfilled() {
    bool filled = true;
    if (name.text.isEmpty ||
        start.text.isEmpty ||
        end.text.isEmpty ||
        supername.text.isEmpty) {
      filled = false;
    }
    return filled;
  }

  Map<String, dynamic> asMap() {
    return {
      'NAME': name.text,
      'STARTDATE': start.text,
      'ENDDATE': end.text,
      'LEAD': superid,
      'DESCRIPTION': description.text,
    };
  }
}

class TaskData {
  final TextEditingController name = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  final TextEditingController username = TextEditingController();
  int? userid;
  int? taskid;
  bool isfilled() {
    bool filled = true;
    if (name.text.isEmpty ||
        start.text.isEmpty ||
        end.text.isEmpty ||
        username.text.isEmpty) {
      filled = false;
    }
    if (userid == null) {
      filled = false;
    }
    return filled;
  }

  Map<String, dynamic> asMap() {
    return {
      'NAME': name.text,
      'STARTDATE': start.text,
      'ENDDATE': end.text,
      'USERID': userid,
      'TASKID': taskid ?? -1,
    };
  }
}

class SubTaskData {
  final TextEditingController name = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  final TextEditingController username = TextEditingController();
  int? userid;
  int? subtaskid;
  bool isfilled() {
    bool filled = true;
    if (name.text.isEmpty ||
        start.text.isEmpty ||
        end.text.isEmpty ||
        username.text.isEmpty) {
      filled = false;
    }
    if (userid == null) {
      filled = false;
    }
    return filled;
  }

  Map<String, dynamic> asMap() {
    return {
      'NAME': name.text,
      'STARTDATE': start.text,
      'ENDDATE': end.text,
      'USERID': userid,
      'SUBTASKID': subtaskid ?? -1,
    };
  }
}
