import 'package:app_movil_dincydet/api/urls.dart';

Future<Map<String, dynamic>?> apiAnalyticsById(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/analytics/byid', dataMap);
  return data;
}
