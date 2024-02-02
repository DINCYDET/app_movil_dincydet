// Endpoint to get documents list
import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

/// Endpoint to get documents list
Future<List<Map<String, dynamic>>?> apiDocumentsGetAll({
  DateTime? startDate,
  DateTime? endDate,
  int? stage,
  required bool isIn,
}) async {
  final dataMap = {
    'STARTDATE': startDate?.toIso8601String(),
    'ENDDATE': endDate?.toIso8601String(),
    'STAGE': stage,
    'IN': isIn,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/documents/all', dataMap);
  if (data == null) return null;
  List<Map<String, dynamic>> documents =
      List<Map<String, dynamic>>.from(data['documents']);
  return documents;
}

/// Endpoint to add a new document
Future<Map<String, dynamic>?> apiDocumentsAdd(dynamic dataMap) async {
  final formdata = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/documents/all/new', formdata);
  return data;
}

// Endpoint to validate a document
Future<Map<String, dynamic>?> apiDocumentsValidate(
    int documentID, bool status, int authIndex) async {
  final dataMap = {
    'ID': documentID,
    'STATUS': status,
    'AUTH_INDEX': authIndex,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/documents/validate', dataMap);
  return data;
}
