import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

// Endpoint to add a stat task
Future<Map<String, dynamic>?> apiStatsAddTask(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/stats/add/task', dataMap);
  return data;
}

// Endpoint to get the list of stat tasks for a user
Future<Map<String, dynamic>?> apiStatsGetTasks(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/stats/get', dataMap);
  return data;
}

// Endpoint to get the list of stat subtasks for a task
Future<Map<String, dynamic>?> apiStatsGetSubTasks(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/get/subtasks', dataMap);
  return data;
}

// Endpoint to add a stat subtask
Future<Map<String, dynamic>?> apiStatsAddSubTasks(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/add/subtasks', dataMap);
  return data;
}

// Endpoint to add a report subtask
Future<Map<String, dynamic>?> apiStatsAddReportSubTasks(dynamic dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/stats/add/report', formData);
  return data;
}

// Endpoint to get the list of reports for a task
Future<List<Map<String, dynamic>>?> apiStatsGetReports(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/get/reports', dataMap);
  if (data == null) return null;
  return List<Map<String, dynamic>>.from(data['reports']);
}

// Endpoint to delete a stat task
Future<Map<String, dynamic>?> apiStatsDeleteTask(int taskId) async {
  final dataMap = {
    'ID': taskId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/delete/task', dataMap);
  return data;
}

// Endpoint to edit a stat task
Future<Map<String, dynamic>?> apiStatsEditTask(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/edit/task', dataMap);
  return data;
}

// Endpoint to validate a stat task
Future<Map<String, dynamic>?> apiStatsValidateTask(int taskId) async {
  final dataMap = {
    'ID': taskId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/validate/task', dataMap);
  return data;
}

// Endpoint to mark stat task as completed
Future<Map<String, dynamic>?> apiStatsCompleteTask(int taskId) async {
  final dataMap = {
    'ID': taskId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/complete/task', dataMap);
  return data;
}

// Endpoint to query a completion validation for a task
Future<Map<String, dynamic>?> apiStatsQueryCompletionValidation(
    int taskId) async {
  final dataMap = {
    'ID': taskId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/stats/querycomplete/task', dataMap);
  return data;
}
