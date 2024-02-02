import 'package:app_movil_dincydet/api/urls.dart';

Future<Map<String, dynamic>?> apiAssistanceDetailed() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/assistance/formatted/');
  return data;
}

// Endpoint to get the assistance of users
Future<Map<String, dynamic>?> apiAssistanceGetAll() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/assistance/count');
  return data;
}

Future<Map<String, dynamic>?> apiAssistancePartGetAll() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/assistance/part');
  return data;
}

// Endpoint to get detailed assistance of users
Future<Map<String, dynamic>?> apiAssistanceGetDetailed() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/assistance/detailed/');
  return data;
}

// Endpoint to get the daily part
Future<List<Map<String, dynamic>>?> apiAssistanceGetDaily() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/assistance/dailypart');
  if (data == null) return null;
  List<Map<String, dynamic>> dailyPart =
      List<Map<String, dynamic>>.from(data['assistance']);
  return dailyPart;
}

// Endpoint to get the assistence summary for user
Future<List<Map<String, dynamic>>?> apiAssistanceSummary(int dni) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/assistance/user/summary', dataMap);
  if (data == null) return null;
  List<Map<String, dynamic>> summary =
      List<Map<String, dynamic>>.from(data['assistance']);
  return summary;
}

// Endpoint to get the visits of all users
Future<Map<String, dynamic>?> apiAssistanceVisits() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/visits/get/all');
  return data;
}

//Endpoint to get user assistance status
Future<Map<String, dynamic>?> apiGetAssistanceStatus() async {
  Map<String, dynamic>? data = await dioPost('$apiURI/user/get/assistance', {});
  return data;
}

//Endpoint to set user assistance status
Future<Map<String, dynamic>?> apiSetAssistanceStatus() async {
  Map<String, dynamic>? data = await dioPost('$apiURI/user/set/assistance', {});
  return data;
}

//Endpoint to set user
Future<Map<String, dynamic>?> apiSetPosition(int posId) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/visits/set', {'POSID': posId});
  return data;
}
