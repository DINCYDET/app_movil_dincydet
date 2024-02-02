import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

/// Endpoint to register a new received document
Future<Map<String, dynamic>?> apiDocumentReceivedNew(
    Map<String, dynamic> dataMap) async {
  final formdata = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/managedocs/new/received', formdata);
  return data;
}

/// Endpoint to register a new received document
Future<Map<String, dynamic>?> apiEditDocumentReceived(
    Map<String, dynamic> dataMap) async {
  final formdata = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/managedocs/edit', formdata);
  return data;
}

/// Endpoint to register a new transmitted document
Future<Map<String, dynamic>?> apiDocumentTransmittedNew(
    Map<String, dynamic> dataMap) async {
  final formdata = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/managedocs/new/transmitted', formdata);
  return data;
}

/// Endpoint to assign a document to a user
Future<Map<String, dynamic>?> apiDocumentAssign(
    Map<String, dynamic> dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/managedocs/assign', dataMap);
  return data;
}

/// Endpoint to complete an assigned document
Future<Map<String, dynamic>?> apiDocumentComplete(
    Map<String, dynamic> dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/managedocs/complete', formData);
  return data;
}

/// Endpoint to get received documents list
Future<List<Map<String, dynamic>>?> apiDocumentReceivedList(
  String? startDate,
  String? endDate,
  int? documentType,
  int? dependencie,
  String? document,
  String? issue,
) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'DOCTYPE': documentType,
    'DESTINATION': dependencie,
    'DOCUMENT': document,
    'ISSUE': issue,
    'DOCUMENTCLASS': "received"
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/managedocs/all', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['documents']);
}

/// Endpoint to get transmitted documents list
Future<List<Map<String, dynamic>>?> apiDocumentsTransmittedList(
  String? startDate,
  String? endDate,
  int? documentType,
  int? dependencie,
  String? document,
  String? issue,
) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'DOCTYPE': documentType,
    'DESTINATION': dependencie,
    'DOCUMENT': document,
    'ISSUE': issue,
    'DOCUMENTCLASS': "transmitted"
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/managedocs/all', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['documents']);
}

/// Endpoint to get assigned documents list
Future<List<Map<String, dynamic>>?> apiDocumentsAssignedList(
  String? startDate,
  String? endDate,
  int? documentType,
  int? dependencie,
  String? document,
  String? issue,
  bool pending,
) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'DOCTYPE': documentType,
    'DESTINATION': dependencie,
    'DOCUMENT': document,
    'ISSUE': issue,
    'DOCUMENTCLASS': "assigned",
    'PENDING': pending,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/managedocs/all', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['documents']);
}

/// Endpoint to delete a document
Future<Map<String, dynamic>?> apiDocumentDelete(int id) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/managedocs/delete', {'ID': id});
  return data;
}
