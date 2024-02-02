import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/tasks_subtasks_class.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class NewProjectProvider extends ChangeNotifier {
  NewProjectProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateSuggestions();
    });
  }

  final BaseData basedata = BaseData();

  void onTapRegister() async {
    if (!basedata.isfilled()) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Complete los campos de proyecto'),
        ),
      );
      return;
    }
    // Generamos el payload
    final Map<String, dynamic> base = basedata.asMap();
    final Map<String, dynamic>? response = await apiProjectsAdd(base);
    if (response == null) {
      return;
    }
    Navigator.of(navigatorKey.currentContext!).pop(true);
  }

  // Get All users
  List<SelectedListItem> suggestions = <SelectedListItem>[];
  void updateSuggestions() async {
    Map<String, dynamic>? response = await apiUsersGetAll();
    if (response == null) {
      return;
    }
    final users = response['users'] as List<dynamic>;
    suggestions = users.map((e) {
      return SelectedListItem(
        name: e['FULLNAME'],
        value: e['DNI'].toString(),
        isSelected: false,
      );
    }).toList();
    notifyListeners();
  }

  List<int> members = [];

  void onTapNewMember() {
    DropDownState(
      DropDown(
        dropDownBackgroundColor: const Color(0xFFFBFBFB),
        bottomSheetTitle: const Text(
          'Lista de usuarios',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: suggestions,
        selectedItems: (List<dynamic> selectedList) {
          for (var item in selectedList) {
            //TODO: Add members
          }
        },
        enableMultipleSelection: true,
      ),
    ).showModal(navigatorKey.currentContext!);
  }
}
