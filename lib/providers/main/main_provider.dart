// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:app_movil_dincydet/api/urls.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:quickalert/quickalert.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainProvider {
  Map<String, dynamic>? USERDATA = {}; // Map to store user data
  String TOKEN = ''; // String to store user token
  bool isAdmin = false;
  bool accessToInventory = false;
  bool accessToBudget = false;
  bool accessToPersonal = false;
  bool accessToManagement = false;

  void setPermissions() {
    isAdmin = false;
    accessToInventory = USERDATA!['AT_Inventory'] == true;
    accessToBudget = USERDATA!['AT_Budget'] == true;
    accessToPersonal = USERDATA!['AT_Personal'] == true;
    accessToManagement = USERDATA!['AT_Management'] == true;
    if (USERDATA!['HIERARCHY'] == 1) {
      isAdmin = true;
      accessToInventory = true;
      accessToBudget = true;
      accessToPersonal = true;
      accessToManagement = true;
    }
  }

  IO.Socket socket = IO.io(
    serverBase,
    <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    },
  );

  void initSocket() {
    //SocletIO
    socket.connect();
    socket.onConnect(
      (data) {
        socket.emit('auth', {'token': TOKEN, 'dni': USERDATA!['DNI']});
      },
    );
    socket.on(
      'user_password_changed',
      onPasswordChanged,
    );
    socket.on(
      'GISupdate',
      onGISupdate,
    );
    socket.on(
      'AssistanceUpdate',
      onAssistanceUpdate,
    );
    socket.on(
      'newMessage',
      onMessage,
    );
  }

  void onPasswordChanged(dynamic data) async {
    print('Se Cambio la contraseña');
    await QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.info,
      text: 'Se Cambio la contraseña',
      barrierDismissible: true,
    );
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  /// Stream to update GIS data
  final StreamController _GISupdateController = StreamController.broadcast();
  Stream get GISupdateStream => _GISupdateController.stream;

  void onGISupdate(dynamic data) {
    _GISupdateController.add(data);
  }

  /// Stream to update Assistance data
  final StreamController _AssistanceController = StreamController.broadcast();
  Stream get AssistanceStream => _AssistanceController.stream;

  void onAssistanceUpdate(dynamic data) {
    _AssistanceController.add(data);
  }

  /// Tickets functions
  void joinToTicket(int ticketid) {
    socket.emit('joinToTicket', {'ticketid': ticketid});
  }

  void leaveTicket(int ticketid) {
    socket.emit('leaveFromTicket', {'ticketid': ticketid});
  }

  final StreamController _MessagesController = StreamController.broadcast();
  Stream get MessagesStream => _MessagesController.stream;

  void onMessage(dynamic data) {
    _MessagesController.add(data);
  }
}
