import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';

//Endpoint to add a new ticket
Future<Map<String, dynamic>?> apiMessagesAdd(dynamic dataMap) async {
  final formData = FormData.fromMap(dataMap);
  Map<String, dynamic>? data = await dioForm(
    '$apiURI/messages/add/',
    formData,
    showLoading: false,
  );
  return data;
}

//Endpoint to get all messages from a ticket
Future<Map<String, dynamic>?> apiMessagesGet(int ticketid) async {
  final dataMap = {
    'CHATID': ticketid,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/messages/get/', dataMap);
  return data;
}
