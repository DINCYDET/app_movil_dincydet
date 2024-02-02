import 'package:app_movil_dincydet/api/urls.dart';


// Api to get the task list of a project
Future<List<Map<String, dynamic>>?> apiTasksListFromProject(
    int projectID) async {
  final dataMap = {
    'PRJID': projectID,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/tasks/project', dataMap);
  if (data == null) return null;
  List<Map<String, dynamic>> tasks =
      List<Map<String, dynamic>>.from(data['tasks']);
  return tasks;
}

// Api to get the subtask list of a task
Future<List<Map<String, dynamic>>?> apiTasksListFromTask(int taskID) async {
  final dataMap = {
    'TASKID': taskID,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/subtasks/task', dataMap);
  if (data == null) return null;
  List<Map<String, dynamic>> tasks =
      List<Map<String, dynamic>>.from(data['subtasks']);
  return tasks;
}

// Api to set the advance of a task
Future<Map<String, dynamic>?> apiTasksSetAdvance(
    int taskID, int advance) async {
  final dataMap = {
    'TASKID': taskID,
    'ADVANCE': advance,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tasks/advance/set', dataMap);
  if (data == null) return null;
  return data;
}

// Api to set the advance of a subtask
Future<Map<String, dynamic>?> apiSubtasksSetAdvance(
    int subtaskID, int advance) async {
  final dataMap = {
    'SUBTASKID': subtaskID,
    'ADVANCE': advance,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/subtasks/advance/set', dataMap);
  if (data == null) return null;
  return data;
}
