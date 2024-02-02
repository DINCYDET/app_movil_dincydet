import 'dart:io';
import 'dart:math';

import 'package:app_movil_dincydet/api/api_stats.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsUserProvider extends ChangeNotifier {
  StatsUserProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserTasks();
    });
  }
  //int? selectedUser;
  int? selectedIndex;

  TextEditingController nameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // For subtasks advance
  TextEditingController descriptionController = TextEditingController();
  double sliderValue = 0;

  List<Map<String, dynamic>> tasks = [];

  List<Map<String, dynamic>> subTasks = [];

  List<Map<String, dynamic>> overTimeTasks = [
    {
      'NAME': 'Tarea 1',
      'DAYS': 10,
      'VALIDATED': false,
    }
  ];

  List<Map<String, dynamic>> projects = [
    {
      'NAME': 'Proyecto 1',
      'ADVANCE': 78,
    }
  ];
  Widget child = Container();
  var rng = Random();

  final TextEditingController searchController = TextEditingController();

  void onTapTask(int index) async {
    if (selectedIndex == index) return;
    selectedIndex = index;
    nameController.text = selectedTask!['NAME'];
    startDateController.text = isoToLocalDate(selectedTask!['STARTDATE']);
    endDateController.text = isoToLocalDate(selectedTask!['ENDDATE']);
    getUserSubTasks();
    notifyListeners();
    // getUserTasks();
  }

  void getUserTasks() async {
    final dataMap = {
      'ID':
          Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
              .USERDATA?['DNI'],
    };
    Map<String, dynamic>? data = await apiStatsGetTasks(dataMap);
    if (data == null) return;
    tasks = List<Map<String, dynamic>>.from(data['tasks']);
    notifyListeners();
  }

  void getUserSubTasks() async {
    List<dynamic> subtasks = tasks[selectedIndex!]['SUBTASKS'];
    subTasks = subtasks.map((e) {
      e['name'] = e['NAME'];
      e['startDate'] = isoParseDateTime(e['STARTDATE']);
      e['endDate'] = isoParseDateTime(e['ENDDATE']);
      e['startDateController'] =
          TextEditingController(text: isoToLocalDate(e['STARTDATE']));
      e['endDateController'] =
          TextEditingController(text: isoToLocalDate(e['ENDDATE']));
      e['nameController'] = TextEditingController(text: e['name']);
      return Map<String, dynamic>.from(e);
    }).toList();
    notifyListeners();
  }

  Map<String, dynamic>? get selectedTask {
    if (selectedIndex == null) return null;
    return tasks[selectedIndex!];
  }

  Map<String, dynamic>? get selectedSubTask {
    if (subTaskIndex == null) return null;
    return subTasks[subTaskIndex!];
  }

  bool? get validated {
    if (selectedIndex == null) return null;
    return tasks[selectedIndex!]['VALIDATED'];
  }

  void onTapValidation() async {
    if (selectedTask!['VALIDATED'] != null) {
      return;
    }
    // Add the subtasks to the task
    // TODO: Add code to validate empty fields
    final dataMap = {
      'ID': selectedTask!['ID'],
      'SUBTASKS': [],
    };
    for (var st in subTasks) {
      if (st['nameController'].text.isEmpty) return;
      if (st['startDate'] == null) return;
      if (st['endDate'] == null) return; //TODO: Optimize
      st['name'] = st['nameController'].text;
      dataMap['SUBTASKS'].add({
        'NAME': st['name'],
        'STARTDATE': st['startDate'].toIso8601String(),
        'ENDDATE': st['endDate'].toIso8601String(),
      });
    }
    Map<String, dynamic>? data = await apiStatsAddSubTasks(dataMap);
    if (data == null) return;
    tasks[selectedIndex!]['VALIDATED'] = false;
    getUserTasks();
    notifyListeners();
  }

  void onTapAddSubTask() {
    subTasks.add({
      'nameController': TextEditingController(),
      'name': '',
      'startDateController': TextEditingController(),
      'endDateController': TextEditingController(),
      'startDate': null,
      'endDate': null,
    });
    notifyListeners();
  }

  void onTapRemoveSubTask(int index) {
    subTasks.removeAt(index);
    notifyListeners();
  }

  void onTapStartDate(int index) async {
    final startDate = subTasks[index]['startDate'];
    final endDate = subTasks[index]['endDate'];
    DateTime? date = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: startDate ??
          isoParseDateTime(selectedTask!['STARTDATE']) ??
          DateTime.now(),
      firstDate: isoParseDateTime(selectedTask!['STARTDATE']) ?? DateTime.now(),
      lastDate: endDate ??
          isoParseDateTime(selectedTask!['ENDDATE']) ??
          DateTime(2500),
    );
    if (date == null) {
      return;
    }
    subTasks[index]['startDate'] = date;
    subTasks[index]['startDateController'].text =
        DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  void onTapEndDate(int index) async {
    final startDate = subTasks[index]['startDate'];
    DateTime? date = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: startDate ??
          isoParseDateTime(selectedTask!['STARTDATE']) ??
          DateTime.now(),
      firstDate: startDate ??
          isoParseDateTime(selectedTask!['STARTDATE']) ??
          DateTime.now(),
      lastDate: isoParseDateTime(selectedTask!['ENDDATE']) ?? DateTime(2500),
    );
    if (date == null) {
      return;
    }
    subTasks[index]['endDate'] = date;
    subTasks[index]['endDateController'].text =
        DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  int? subTaskIndex;
  void onChangedSubTask(int? value) {
    if (subTaskIndex == value) return;
    subTaskIndex = value;
    sliderValue = (selectedSubTask!['ADVANCE'] as int).toDouble();
    notifyListeners();
  }

  void onSliderChanges(double value) {
    sliderValue = value;
    notifyListeners();
  }

  DateTime get minStartDate {
    if (subTasks.isEmpty) return DateTime.now();
    return subTasks.map((e) => e['startDate']).reduce(
        (value, element) => value!.isBefore(element!) ? value : element)!;
  }

  DateTime get maxEndDate {
    if (subTasks.isEmpty) return DateTime.now();
    return subTasks.map((e) => e['endDate']).reduce(
        (value, element) => value!.isAfter(element!) ? value : element)!;
  }

  Duration get maxDuration {
    if (subTasks.isEmpty) return Duration.zero;
    // Return the difference between the max and min dates
    return maxEndDate.difference(minStartDate);
  }

  File? pickedFile;
  void onTapAddFile() async {
    final results = await FilePicker.platform.pickFiles(
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );
    if (results == null) return;
    pickedFile = File(results.files.single.path!);
    notifyListeners();
  }

  String? get fileName {
    if (pickedFile == null) return null;
    return pickedFile!.path.replaceAll('\\', '/').split('/').last;
  }

  void onTapCancel() {
    descriptionController.text = '';
    sliderValue = 0;
    pickedFile = null;
    subTaskIndex = null;
    notifyListeners();
  }

  void onTapUpdate() async {
    final dataMap = {
      'SUBTASKID': selectedSubTask!['ID'],
      'DESCRIPTION': descriptionController.text,
      'PROGRESS': sliderValue.toInt(),
    };
    if (pickedFile != null) {
      dataMap['files'] = await MultipartFile.fromFile(pickedFile!.path);
    }
    final results = await apiStatsAddReportSubTasks(dataMap);
    if (results == null) return;
    // Show an alert dialog that explains that the report was sent
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Reporte enviado'),
        content: const Text('El reporte fue enviado con éxito'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    selectedSubTask!['ADVANCE'] = sliderValue.toInt();
    getUserTasks();
  }

  int get completedSubTasks {
    // Count the number of completed subtasks
    int completed =
        subTasks.where((element) => element['ADVANCE'] == 100).length;
    return completed;
  }

  int get nonCompletedSubTasks {
    int total = subTasks.length;
    // Count the number of completed subtasks
    int completed =
        subTasks.where((element) => element['ADVANCE'] == 100).length;
    return total - completed;
  }

  String searchText = '';
  void onChangedSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  String get completionLabel {
    if (selectedTask!['COMPLETIONVALIDATED'] == null) {
      return 'Solicitar validación\nde terminación';
    } else if (selectedTask!['COMPLETIONVALIDATED'] == false) {
      return 'Validación de terminación\nsolicitada';
    } else {
      return 'Tarea completada';
    }
  }

  Color get completionColor {
    if (selectedTask!['COMPLETIONVALIDATED'] == null) {
      return const Color(0x822B9D0F);
    } else if (selectedTask!['COMPLETIONVALIDATED'] == false) {
      return Colors.yellow.shade700;
    } else {
      return Colors.blueGrey.shade200;
    }
  }

  void onTapQueryCompletion() async {
    if (selectedTask!['COMPLETIONVALIDATED'] != null) {
      return;
    }
    bool? complete = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Solicitar validación de terminación'),
        content: const Text(
          '¿Está seguro que desea solicitar la validación de terminación de la tarea?',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: MC_darkblue,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: MC_darkblue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (complete == null) return;
    final results =
        await apiStatsQueryCompletionValidation(selectedTask!['ID']);
    if (results == null) return;
    getUserTasks();
  }

  void onTapAdminMode() {
    navigatorKey.currentState!.pushReplacementNamed('/statsadminpage');
  }
}
