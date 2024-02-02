import 'package:app_movil_dincydet/api/urls.dart';

// Endpoint to send an alertto all users
Future<Map<String, dynamic>?> apiAlertsSend(int alertType) async {
  Map<String, dynamic>? data = await dioGet('$apiURI/alerts/$alertType');
  return data;
}

// Endpoint to call user
Future<Map<String, dynamic>?> apiAlertsCall(int userid) async {
  final dataMap = {
    'ID': userid,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/alert/call', dataMap);
  return data;
}
