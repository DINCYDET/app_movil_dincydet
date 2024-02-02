import 'package:app_movil_dincydet/api/urls.dart';

import 'package:dio/dio.dart';

Future<Map<String, dynamic>?> apiLoginCredentials(
    String dni, String password) async {
  final dataMap = {
    'DNI': dni.trim(),
    'PASSWORD': password,
  };
  Map<String, dynamic>? response =
      await dioPost('$apiURI/login', FormData.fromMap(dataMap));
  return response;
}

Future<Map<String, dynamic>?> apiLoginToken() async {
  Map<String, dynamic>? response = await dioGet('$apiURI/login');
  return response;
}

Future<Map<String, dynamic>?> apiSendFirebaseToken(String token) async {
  final dataMap = {
    'FBTOKEN': token,
  };
  Map<String, dynamic>? response =
      await dioPost('$apiURI/fbtoken/set', dataMap);
  return response;
}
