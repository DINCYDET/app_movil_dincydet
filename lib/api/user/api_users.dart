import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

// Obtener todos los usuarios
Future<Map<String, dynamic>?> apiUsersGetAll() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/users/get/all');
  return data;
}

// Obtener todos los usuarios con detalles
Future<List<Map<String, dynamic>>?> apiUsersGetAllDetailed() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/users/get/all/detailed');
  if (data == null) {
    return null;
  }
  return List<Map<String, dynamic>>.from(data['users']);
}

// Obtener solo oficiales
Future<Map<String, dynamic>?> apiUsersGetOficials() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/users/get/oficials/');
  return data;
}

// Endpoint to get only persuba users
Future<Map<String, dynamic>?> apiUsersGetPersuba() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/users/get/persuba');
  return data;
}

Future<Map<String, dynamic>?> apiUsersGetDetails(int dni) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/user/get/', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiUsersEdit(dynamic dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data = await dioForm('$apiURI/user/edit', formData);
  return data;
}

Future<Map<String, dynamic>?> apiUsersAdd(dynamic dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data = await dioForm('$apiURI/user/add', formData);
  return data;
}

Future<Map<String, dynamic>?> apiUsersDelete(int dni) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/users/delete', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiUsersChangePassword(
    int dni, String password) async {
  final dataMap = {
    'DNI': dni,
    'PASSWORD': password,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/users/change/password', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiUsersChangeDNI(int dni, int newDNI) async {
  final dataMap = {
    'DNI': dni,
    'NEWDNI': newDNI,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/users/change/dni', dataMap);
  return data;
}
