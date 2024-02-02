import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

// Endpoint to register a new budget
Future<Map<String, dynamic>?> apiBudgetNew(Map<String, dynamic> dataMap) async {
  final formdata = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/budgets/all/new', formdata);
  return data;
}

// Endpoint to get budgets list
Future<List<Map<String, dynamic>>?> apiBudgetList(
    String? startDate, String? endDate, dynamic status) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'STATUS': status,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/budgets/all', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['budgets']);
}

// Endpoint to get detailed budget list
Future<List<Map<String, dynamic>>?> apiBudgetDetailedList(
    String? startDate, String? endDate, dynamic status) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'STATUS': status,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/budgets/all/detailed', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['items']);
}

// Endpoint to confirm a budget
Future<Map<String, dynamic>?> apiBudgetConfirm(
    Map<String, dynamic> dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/budgets/confirm', dataMap);
  return data;
}


// Endpoint to get the items of a budget
Future<List<Map<String, dynamic>>?> apiBudgetItems(int budgetId) async {
  final dataMap = {
    'ID': budgetId,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/budgets/items', dataMap);
  if (data == null) return null;
  return List<Map<String, dynamic>>.from(data['items']);
}
