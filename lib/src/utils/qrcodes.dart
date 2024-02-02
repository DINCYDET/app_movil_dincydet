import 'package:encrypt/encrypt.dart';

final cryptKey = Key.fromUtf8('xGojaQqOYc7vQ++5Sq20oEFJyQhQVmoz');
final iv = IV.fromLength(16);
String baseQR = 'DINCYDET-';

final encrypter = Encrypter(AES(cryptKey));

String qrStringInventory(int value) {
  String text = '${baseQR}INV-$value';
  return encrypter.encrypt(text, iv: iv).base64;
}

String qrStringUser(int value) {
  String text = '${baseQR}USR-$value';
  return encrypter.encrypt(text, iv: iv).base64;
}

String qrStringGIS(int value) {
  String text = '${baseQR}GIS-$value';
  return encrypter.encrypt(text, iv: iv).base64;
}

String qrAssistance() {
  String text = 'DINCYDET-GEN-ASSISTANCE';
  return encrypter.encrypt(text, iv: iv).base64;
}

String qrDecode(String text) {
  return encrypter.decrypt64(text, iv: iv);
}

List<String> qrLocations() {
  List<String> data = [];
  for (var i = 1; i <= 30; i++) {
    data.add(qrStringGIS(i));
  }
  return data;
}
