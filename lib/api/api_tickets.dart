import 'package:app_movil_dincydet/api/urls.dart';

//Endpoint to add a new ticket
Future<Map<String, dynamic>?> apiTicketsAdd(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioForm('$apiURI/tickets/add', dataMap);
  return data;
}

Future<Map<String, dynamic>?> apiTicketsDelete(dynamic dataMap) async {
  Map<String, dynamic>? data = await dioPost('$apiURI/tickets/delete', dataMap);
  return data;
}

// Endpoint to get usertickets
Future<List<Map<String, dynamic>>?> apiTicketsListUser({
  required bool toUser,
  required int status,
  required int ticktype,
}) async {
  final dataMap = {
    'TICKTYPE': ticktype,
    'STATUS': status,
    'TOUSER': toUser,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/tickets/user', dataMap);
  if (data == null) return null;
  return List<Map<String, dynamic>>.from(data['tickets']);
}

Future<Map<String, dynamic>?> apiTicketsSummary() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/tickets/summary');
  return data;
}

Future<Map<String, dynamic>?> apiTicketsGetProjects(dynamic dataMap) async {
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tickets/project', dataMap);
  return data;
}

// Endpoint to get all tickets sended from user
Future<Map<String, dynamic>?> apiTicketsGetOut(int dni) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tickets/user/get/out/', dataMap);
  return data;
}

// Endpoint to get all tickets received from user
Future<Map<String, dynamic>?> apiTicketsGetIn(int dni) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tickets/user/get/in/', dataMap);
  return data;
}

// Endpoint to get count of tickets for each category
Future<Map<String, dynamic>?> apiTicketsGetCount({
  required bool isIn,
  required bool isOpen,
}) async {
  final dataMap = {'status': isOpen ? 0 : 1};
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tickets/count/${isIn ? 'in' : 'out'}', dataMap);
  return data;
}

// Endpoint to get the count of tickets for an user
Future<Map<String, dynamic>?> apiTicketsGetCountUser({
  required int dni,
}) async {
  final dataMap = {
    'DNI': dni,
  };
  Map<String, dynamic>? data =
      await dioPost('$apiURI/tickets/count/user', dataMap);
  return data;
}

// Endpoint to close a ticket
Future<Map<String, dynamic>?> apiTicketsClose(int ticketID) async {
  final dataMap = {'ID': ticketID};
  Map<String, dynamic>? data = await dioPost('$apiURI/tickets/close', dataMap);
  return data;
}
