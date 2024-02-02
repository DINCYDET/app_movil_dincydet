import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

// const String serverBase = 'http://192.168.18.6:7000';
const String serverBase = 'http://172.16.1.4:5000';
// const String serverBase = 'http://sv-7FahANL0Ey.cloud.elastika.pe:7000';
const String apiBase = '$serverBase/api/v1/';
const String apiURI = '$serverBase/api/v1'; // We use this

Future<Map<String, dynamic>?> dioGet(String url) async {
  final String token = Provider.of<MainProvider>(
    navigatorKey.currentContext!,
    listen: false,
  ).TOKEN;
  Response<dynamic>? response;
  QuickAlert.show(
    context: navigatorKey.currentContext!,
    type: QuickAlertType.loading,
    barrierDismissible: false,
  );
  try {
    response = await Dio().get(
      url,
      options: Options(
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500;
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Dio get nulled');
    }
  }
  Navigator.of(navigatorKey.currentContext!).pop();
  if (response == null || response.statusCode == 404) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Ocurrio un problema',
    );
    return null;
  }
  if (response.statusCode == 401) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Token invalido',
    );
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil('/login', (route) => false);
    return null;
  }
  return response.data;
}

Future<Map<String, dynamic>?> dioPost(String url, dynamic dataMap) async {
  final String token = Provider.of<MainProvider>(
    navigatorKey.currentContext!,
    listen: false,
  ).TOKEN;
  Response<dynamic>? response;
  QuickAlert.show(
    context: navigatorKey.currentContext!,
    type: QuickAlertType.loading,
    barrierDismissible: false,
  );
  try {
    response = await Dio().post(
      url,
      data: dataMap,
      options: Options(
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500;
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Dio catch error');
    }
  }
  Navigator.of(navigatorKey.currentContext!).pop();
  if (response == null || response.statusCode == 404) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Ocurrio un problema',
    );
    return null;
  }
  if (response.statusCode == 401) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Token invalido',
    );
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil('/login', (route) => false);
    return null;
  }
  return response.data;
}

Future<Map<String, dynamic>?> dioForm(String url, FormData dataMap,
    {bool showLoading = true}) async {
  final String token = Provider.of<MainProvider>(
    navigatorKey.currentContext!,
    listen: false,
  ).TOKEN;

  var dio = Dio();
  dio.options.connectTimeout = 5000;
  dio.options.sendTimeout = 8000;

  Response<dynamic>? response;
  if (showLoading) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.loading,
      barrierDismissible: false,
    );
  }
  try {
    response = await dio.post(
      url,
      data: dataMap,
      options: Options(
        validateStatus: (status) {
          if (status == null) return false;
          return status < 500;
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print('Dio get nulled');
    }
  }
  if (showLoading) {
    Navigator.of(navigatorKey.currentContext!).pop();
  }
  if (response == null || response.statusCode == 404) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Ocurrio un problema',
    );
    return null;
  }
  if (response.statusCode == 401) {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.warning,
      title: 'Token invalido',
    );
    Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil('/login', (route) => false);
    return null;
  }
  return response.data;
}
