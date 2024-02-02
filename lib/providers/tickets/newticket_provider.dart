import 'dart:io';
import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/api/projects/api_tasks.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketdetail_utils.dart';
import 'package:dio/dio.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewTicketProvider extends ChangeNotifier {
  NewTicketProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateSuggestions();
      updateProjects();
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // Tipo de ticket
  List<Ttypes> ttypeitems = Ttypes.values;
  Ttypes? ttypesel;

  // Enviar ticket

  bool isComplete() {
    if (ttypesel == null) {
      return false;
    }
    if (ttypesel == Ttypes.Proyecto) {
      if (prjid == null) {
        return false;
      }
    }
    if (nameController.text.isEmpty || priority == null || toUserDNI == null) {
      return false;
    }
    return true;
  }

  void sendTicket() async {
    if (!isComplete()) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete todos los campos',
          ),
        ),
      );
      return;
    }
    Map<String, dynamic> dataMap = {
      'SECONDID': toUserDNI,
      'TYPE': ttypesel!.index,
      'NAME': nameController.text,
      'DESCRIPTION': descController.text,
      'PRIORITY': priority,
    };
    if (ttypesel == Ttypes.Proyecto) {
      dataMap['PRJID'] = prjid;
      dataMap['TASKID'] = taskid;
      dataMap['SUBTASKID'] = subtaskid;
    }
    if (pickedFile != null) {
      dataMap['files'] = await MultipartFile.fromFile(pickedFile!.path);
    }
    var formData = FormData.fromMap(dataMap);
    Map<String, dynamic>? data = await apiTicketsAdd(formData);
    if (data == null) {
      return;
    }
    Navigator.of(navigatorKey.currentContext!).pop(true);
  }

  void onDropdownChange(Ttypes tt) {
    ttypesel = tt;
    if (ttypesel != Ttypes.Proyecto) {
      prjid = null;
      prjname.text = '';
      taskid = null;
      taskname.text = '';
      subtaskid = null;
      subtaskname.text = '';
      onTapCheckTasks(false);
      return;
    }
    notifyListeners();
  }

  bool get isSecurity {
    return ttypesel == Ttypes.Seguridad;
  }

  bool get isProject {
    return ttypesel == Ttypes.Proyecto;
  }

  bool get isFalta {
    return ttypesel == Ttypes.Falta;
  }

  bool get isTarea {
    return ttypesel == Ttypes.Tarea;
  }

  final TextEditingController username = TextEditingController();
  List<SelectedListItem> suggestions = <SelectedListItem>[];

  int? toUserDNI;

  void onTapSendTo() {
    DropDownState(
      DropDown(
        dropDownBackgroundColor: const Color(0xFFFBFBFB),
        bottomSheetTitle: const Text(
          'Usuarios',
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
            username.text = item.name;
            toUserDNI = int.parse(item.value);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(navigatorKey.currentContext!);
  }

  void updateSuggestions() async {
    Map<String, dynamic>? data = await apiUsersGetAll();
    if (data == null) {
      return;
    }
    suggestions = (data['users'] as List<dynamic>)
        .map((e) => SelectedListItem(
              name: e['FULLNAME'],
              value: e['DNI'].toString(),
            ))
        .toList();
    notifyListeners();
  }

  int? priority = 1;
  List<Map<String, dynamic>> priorities = [
    {'name': 'Baja (1 día)', 'color': Colors.green},
    {'name': 'Media (3 días)', 'color': Colors.amber},
    {'name': 'Alta (5 días)', 'color': Colors.red},
  ];

  void priorityChange(int? val) {
    priority = val;
    notifyListeners();
  }

  // Code for project ticket support
  final TextEditingController prjname = TextEditingController();
  final TextEditingController taskname = TextEditingController();
  final TextEditingController subtaskname = TextEditingController();

  List<SelectedListItem> prjsuggestions = <SelectedListItem>[];
  List<SelectedListItem> tasksuggestions = <SelectedListItem>[];
  List<SelectedListItem> subtasksuggestions = <SelectedListItem>[];

  int? prjid;
  int? taskid;
  int? subtaskid;

  bool allowTask = false;
  bool allowSubTask = false;
  bool taskcheck = false;
  bool subtaskcheck = false;

  void onTapProject(String name, String val) {
    prjname.text = name;
    prjid = int.parse(val);
    // parentProv.add['prjid'] = prjid;
    taskname.text = '';
    subtaskname.text = '';
    updateTasks();
    notifyListeners();
  }

  void onTapTask(String name, String val) {
    taskname.text = name;
    subtaskname.text = '';
    taskid = int.parse(val);
    updateSubTasks();
    notifyListeners();
  }

  void onTapSubTask(String name, String val) {
    subtaskname.text = name;
    subtaskid = int.parse(val);
    notifyListeners();
  }

  void updateProjects() async {
    final projects = await apiProjectsGetList();
    if (projects == null) return;
    prjsuggestions = projects.map((e) {
      return SelectedListItem(
        name: e['NAME'],
        value: e['ID'].toString(),
        isSelected: false,
      );
    }).toList();
  }

  void updateTasks() async {
    if (prjid == null) return;
    final response = await apiTasksListFromProject(prjid!);
    if (response == null) return;
    tasksuggestions = response.map((e) {
      return SelectedListItem(
        name: e['NAME'],
        value: e['ID'].toString(),
        isSelected: false,
      );
    }).toList();
  }

  void updateSubTasks() async {
    if (taskid == null) return;
    final response = await apiTasksListFromTask(taskid!);
    if (response == null) return;
    subtasksuggestions = response.map((e) {
      return SelectedListItem(
        name: e['NAME'],
        value: e['ID'].toString(),
        isSelected: false,
      );
    }).toList();
  }

  // Checkboxs
  void onTapCheckTasks(bool value) {
    if (value && prjid != null) {
      allowTask = true;
    } else {
      taskid = null;
      allowTask = false;

      taskname.text = '';
      onTapCheckSubTasks(false);
    }

    notifyListeners();
  }

  void onTapCheckSubTasks(bool value) {
    if (value && taskid != null) {
      allowSubTask = true;
    } else {
      subtaskid = null;
      allowSubTask = false;
      subtaskname.text = '';
    }
    notifyListeners();
  }

  File? pickedFile;
  void pickFile() async {
    FilePickerResult? fileResult;
    try {
      fileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
        lockParentWindow: true,
      );
    } catch (e) {
      print(e);
      return;
    }
    // Allow user to pick file from device
    if (fileResult == null) {
      return;
    }
    pickedFile = File(fileResult.files.single.path!);
    notifyListeners();
  }

  String get fileName {
    if (pickedFile == null) {
      return 'No file selected';
    }
    return pickedFile!.path.replaceAll('\\', '/').split('/').last;
  }
}
