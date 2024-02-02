import 'package:app_movil_dincydet/api/urls.dart';

Future<List<Map<String, dynamic>>?> apiAccessAll() async {
  Map<String, dynamic>? data = await dioGet('$apiURI/access/list');
  if (data == null) return null;
  List<Map<String, dynamic>> access =
      List<Map<String, dynamic>>.from(data['access']);
  return access;
}

Future<Map<String, dynamic>?> apiAccessAdd(
    String accessType, int index, int? userid) async {
  final dataMap = {
    'TYPE': accessType,
    'INDEX': index,
    'USERID': userid,
  };
  Map<String, dynamic>? data = await dioPost('$apiURI/access/add', dataMap);
  return data;
}
