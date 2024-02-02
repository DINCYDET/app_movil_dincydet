import 'package:app_movil_dincydet/api/urls.dart';

String latestApkURI = "$apiURI/version/latest";
String appCurrentVersion = "1.0.0";

Future<Map<String, dynamic>?> apiQueryLatestVersion() async {
  Map<String, dynamic>? results = await dioGet('$apiURI/version');
  return results;
}
