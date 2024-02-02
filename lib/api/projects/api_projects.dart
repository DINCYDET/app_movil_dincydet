import 'package:app_movil_dincydet/api/urls.dart';

// Api for add new project to database
Future<Map<String, dynamic>?> apiProjectsAdd(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/projects/add', dataMap);
  return data;
}

// Api for edit project in database
Future<Map<String, dynamic>?> apiProjectsEdit(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/projects/edit', dataMap);
  return data;
}

// Api for delete project from database
Future<Map<String, dynamic>?> apiProjectsDelete(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/delete/', dataMap);
  return data;
}

// Api for get all projects detailed
Future<Map<String, dynamic>?> apiProjectsGetAllDetailed() async {
  Map<String, dynamic>? data =
      await dioGet('$apiURI/projects/get/all/detailed');
  return data;
}

// Api for get projects list
Future<List<Map<String, dynamic>>?> apiProjectsGetList() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/projects/get/all');
  if (data == null) return null;
  List<Map<String, dynamic>> projects =
      List<Map<String, dynamic>>.from(data['projects']);
  return projects;
}

// Api for get projects count
Future<Map<String, dynamic>?> apiProjectsGetCount() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/projects/count/');
  return data;
}

// Api for get project details
Future<Map<String, dynamic>?> apiProjectsGetDetails(int projectID) async {
  final dataMap = {
    'PID': projectID,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/detail/', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiProjectsGetFiles(int projectId) async {
  final dataMap = {
    'ID': projectId,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/projects/files', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiProjectsAddFile(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioForm('$apiURI/projects/addfile', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiProjectsItemDelete(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/item/delete', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiProjectsFileDelete(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/file/delete', dataMap);
  return data;
}

// Api for edit project details
Future<Map<String, dynamic>?> apiProjectsEditDetails(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/editdetails', dataMap);
  return data;
}

// Api for members
Future<Map<String, dynamic>?> apiMembersGetAll(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/members', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiMembersAdd(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/members/add', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiMembersDelete(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/members/delete', dataMap);
  return data;
}

// Api for get tasks for project
Future<Map<String, dynamic>?> apiProjectsGetTasks(int projectID) async {
  final dataMap = {
    'PRJID': projectID,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/get/tasks', dataMap);
  return data;
}

// Api for get inventory items list for project
Future<List<Map<String, dynamic>>?> apiProjectsGetInventoryItems(
    int projectID) async {
  final dataMap = {
    'ID': projectID,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/inventory', dataMap);
  if (data == null) return null;
  return List<Map<String, dynamic>>.from(data['inventory']);
}

// Api for get projects list for user
Future<Map<String, dynamic>?> apiProjectsGetUserProjects(
    dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/get/user', dataMap);
  return data;
}

// Endpoint for get list of budgets for project
Future<List<Map<String, dynamic>>?> apiProjectsGetBudgets(int projectID) async {
  final dataMap = {
    'ID': projectID,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/budgets/get', dataMap);
  if (data == null) return null;
  List<Map<String, dynamic>> budgets =
      List<Map<String, dynamic>>.from(data['budgets']);
  return budgets;
}

// Endpoint to complete a project
Future<Map<String, dynamic>?> apiProjectsComplete(int projectId) async {
  final dataMap = {
    'ID': projectId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/projects/complete', dataMap);
  return data;
}

// Endpoint to get the users list for a project
Future<Map<String, dynamic>?> apiProjectsGetUsers(int projectId) async {
  final dataMap = {
    'ID': projectId,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/projects/users', dataMap);
  return data;
}
