import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

// Endpoint to get all inventory items
Future<List<Map<String, dynamic>>?> apiInventoryGetAll({
  String? startDate,
  String? endDate,
  int? location,
  int? itemType,
  int? origin,
  int? project,
  String? ibp,
}) async {
  final dataMap = {
    'STARTDATE': startDate,
    'ENDDATE': endDate,
    'LOCATION': location,
    'ITEMTYPE': itemType,
    'ORIGIN': origin,
    'PROJECT': project,
    'IBP': ibp,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/inventory/all', dataMap);
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['items']);
}

// Endpoint to get count inventory for plot
Future<Map<String, dynamic>?> apiInventoryGetCountPlot(
    int? itemType, int? origin, int? location) async {
  final dataMap = {
    'ITEMTYPE': itemType,
    'ORIGIN': origin,
    'LOCATION': location,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/inventory/all/plot', dataMap);
  return data;
}

// Endpoint to add a new inventory item
Future<Map<String, dynamic>?> apiInventoryAdd(
    Map<String, dynamic> dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data = await dioForm('$apiURI/inventory/add', formData);
  return data;
}

// Endpoint to update an inventory item
Future<Map<String, dynamic>?> apiInventoryUpdate(
    Map<String, dynamic> dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data =
      await dioForm('$apiURI/inventory/update', formData);
  return data;
}

// Endpoint to delete an inventory item
Future<Map<String, dynamic>?> apiInventoryDelete(int inventoryId) async {
  final dataMap = {
    'ID': inventoryId,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/inventory/delete', dataMap);
  return data;
}
