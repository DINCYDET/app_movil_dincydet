import 'package:app_movil_dincydet/api/api_access.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:flutter/material.dart';

class ControlPanelProvider extends ChangeNotifier {
  ControlPanelProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserList();
      getAccessList();
    });
  }
  List<Map<String, dynamic>> users = [];
  void getUserList() async {
    final data = await apiUsersGetAll();
    if (data == null) {
      return;
    }
    users = List<Map<String, dynamic>>.from(data['users']);
    notifyListeners();
  }

  List<int?> user1 = [null, null, null];
  List<int?> user2 = [null, null, null];
  List<int?> user3 = [null, null];
  List<int?> user4 = [null, null, null];

  List<bool> editable1 = [false, false, false];
  List<bool> editable2 = [false, false, false];
  List<bool> editable3 = [false, false];
  List<bool> editable4 = [false, false, false];

  void onChangedUser4(int? value, int index) {
    if (user4[index] == value) return;
    user4[index] = value;
    notifyListeners();
  }

  void onChangedUser3(int? value, int index) {
    if (user3[index] == value) return;
    user3[index] = value;
    notifyListeners();
  }

  void onChangedUser2(int? value, int index) {
    if (user2[index] == value) return;
    user2[index] = value;
    notifyListeners();
  }

  void onChangedUser1(int? value, int index) {
    if (user1[index] == value) return;
    user1[index] = value;
    notifyListeners();
  }

  void onTapEdit4(int index) {
    if (editable4[index] == true) {
      apiAccessAdd('MAN', index, user4[index]);
    }
    editable4[index] = !editable4[index];
    notifyListeners();
  }

  void onTapEdit3(int index) {
    if (editable3[index] == true) {
      apiAccessAdd('PER', index, user3[index]);
    }
    editable3[index] = !editable3[index];
    notifyListeners();
  }

  void onTapEdit2(int index) {
    if (editable2[index] == true) {
      apiAccessAdd('BUD', index, user2[index]);
    }
    editable2[index] = !editable2[index];
    notifyListeners();
  }

  void onTapEdit1(int index) {
    if (editable1[index] == true) {
      apiAccessAdd('INV', index, user1[index]);
    }
    editable1[index] = !editable1[index];
    notifyListeners();
  }

  void getAccessList() async {
    List<Map<String, dynamic>>? access = await apiAccessAll();
    if (access == null) return;
    for (var item in access) {
      if (item['TYPE'] == 'INV') {
        user1[item['INDEX']] = item['USERID'];
      } else if (item['TYPE'] == 'BUD') {
        user2[item['INDEX']] = item['USERID'];
      } else if (item['TYPE'] == 'PER') {
        user3[item['INDEX']] = item['USERID'];
      } else if (item['TYPE'] == 'MAN') {
        user4[item['INDEX']] = item['USERID'];
      }
    }
    notifyListeners();
  }

  void onTapRemove1(int k) {
    if (editable1[k] == false) return;
    user1[k] = null;
    notifyListeners();
  }

  void onTapRemove2(int k) {
    if (editable2[k] == false) return;
    user2[k] = null;
    notifyListeners();
  }

  void onTapRemove3(int k) {
    if (editable3[k] == false) return;
    user3[k] = null;
    notifyListeners();
  }

  void onTapRemove4(int k) {
    if (editable4[k] == false) return;
    user4[k] = null;
    notifyListeners();
  }
}
