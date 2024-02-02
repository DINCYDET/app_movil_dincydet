import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateUsers();
    });
  }

  List<Map<String, dynamic>> users = [];

  void onTapNewUser() async {
    final isReg =
        await Navigator.pushNamed(navigatorKey.currentContext!, '/newuserpage');
    if (isReg == null || isReg == false) {
      return;
    }
    updateUsers();
  }

  Future<void> updateUsers() async {
    List<Map<String, dynamic>>? data = await apiUsersGetAllDetailed();
    if (data == null) {
      return;
    }
    users = data;
    filteredItems = users;
    // (nombre, dni, cargo, photo)
    notifyListeners();
  }

  void onTapDelete(int index) async {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.confirm,
      text: 'Desea eliminar al usuario',
      confirmBtnText: 'Si',
      cancelBtnText: 'No',
      barrierDismissible: false,
      confirmBtnColor: Colors.red,
      onCancelBtnTap: () {
        Navigator.pop(navigatorKey.currentContext!);
      },
      onConfirmBtnTap: () async {
        Navigator.pop(navigatorKey.currentContext!);
        final dni = users[index]['DNI'];
        Map<String, dynamic>? response = await apiUsersDelete(dni);
        if (response == null) {
          return;
        }
        updateUsers();
      },
    );
  }

  // Filter users
  List<dynamic> filteredItems = [];
  void onChangedSearch(String value) {
    if (value.isEmpty) {
      filteredItems = users;
    } else {
      value = value.toLowerCase();
      filteredItems = [];
      for (var element in users) {
        if (element['FULLNAME'].toString().toLowerCase().contains(value)) {
          filteredItems.add(element);
        }
      }
    }
    notifyListeners();
  }

  void onTapEditUser(int index) async {
    final data = filteredItems[index];
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERID = data['DNI'];
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = data;
    await Navigator.of(navigatorKey.currentContext!).pushNamed('/edituserpage')
        as bool?;

    updateUsers();
  }

  void onTapViewUser(int index) {
    final data = filteredItems[index];
    // print('====================================================== $data');
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERID = data['DNI'];
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = data;
    Navigator.pushNamed(navigatorKey.currentContext!, '/userviewpage');
  }
}