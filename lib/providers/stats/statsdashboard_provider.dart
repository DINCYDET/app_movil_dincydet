
import 'package:app_movil_dincydet/api/api_stats.dart';
import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/stats/stats_dialogs.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';

class StatsDashboardProvider extends ChangeNotifier {
  StatsDashboardProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final hierarchy =
      //   Provider.of<DataProvider>(context, listen: false).hierarchy;
      updateUsers();
    });
  }
  int? selectedIndex;
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> toValidateTasks = [];
  List<Map<String, dynamic>> validatedTasks = [];
  List<Map<String, dynamic>> completedTasks = [];
  List<Map<String, dynamic>> overTimeTasks = [];

  List<Map<String, dynamic>> subtasks = [];

  List<Map<String, dynamic>> projects = [];

  final TextEditingController searchController = TextEditingController();

  void updateUsers() async {
    Map<String, dynamic>? data = await apiUsersGetOficials();
    if (data == null) {
      return;
    }
    users = List<Map<String, dynamic>>.from(data['users']);
    notifyListeners();
  }

  void onTapUser(int index) async {
    if (selectedIndex == index) return;
    selectedIndex = index;
    // Clear all data
    selectedPlotTask = null;
    plotSubTasks = [];
    // Load data
    getUserTasks();
    getUserProjects();
    getUserTicketCount();
    notifyListeners();
    // getUserTasks();
  }

  Map<String, dynamic>? get selectedUser {
    if (selectedIndex == null) return null;
    return users[selectedIndex!];
  }

  void categorizeTasks() {
    toValidateTasks = [];
    validatedTasks = [];
    completedTasks = [];
    overTimeTasks = [];
    final now = DateTime.now();
    for (var task in tasks) {
      if (task['VALIDATED'] != true) {
        toValidateTasks.add(task);
        continue;
      }
      if (task['VALIDATED'] == true && task['COMPLETIONVALIDATED'] != true) {
        validatedTasks.add(task);
      } else if (task['COMPLETIONVALIDATED'] == true) {
        completedTasks.add(task);
      }
      final date = isoParseDateTime(task['ENDDATE']);
      if (date == null) continue;
      if (date.isBefore(now)) {
        task['DAYS'] = date.difference(now).inDays;
        overTimeTasks.add(task);
      }
    }
  }

  Future<void> getUserTasks() async {
    final dataMap = {
      'ID': selectedUser!['DNI'],
    };
    Map<String, dynamic>? data = await apiStatsGetTasks(dataMap);
    if (data == null) return;
    tasks = List<Map<String, dynamic>>.from(data['tasks']);
    print(tasks);
    categorizeTasks();
    notifyListeners();
  }

  void getUserProjects() async {
    final dataMap = {
      'ID': selectedUser!['DNI'],
    };
    Map<String, dynamic>? data = await apiProjectsGetUserProjects(dataMap);
    if (data == null) return;
    projects = List<Map<String, dynamic>>.from(data['projects']);
    notifyListeners();
  }

  int get projectsCount {
    if (projects.isEmpty) return 0;
    return projects.length;
  }

  void onTapNewTask() async {
    Map<String, dynamic>? data = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const StatsNewDialog();
        });
    if (data == null) return;
    data['USERID'] = selectedUser!['DNI'];
    final results = await apiStatsAddTask(data);
    if (results == null) return;
    getUserTasks();
  }

  String searchText = '';
  void onChangedSearch(String value) {
    searchText = value;
    notifyListeners();
  }

  void onTapToValidateDetails(int index) async {
    Map<String, dynamic> selectedTask = toValidateTasks[index];
    selectedTask['startDateController'] =
        TextEditingController(text: isoToLocalDate(selectedTask['STARTDATE']));
    selectedTask['endDateController'] =
        TextEditingController(text: isoToLocalDate(selectedTask['ENDDATE']));
    selectedTask['nameController'] =
        TextEditingController(text: selectedTask['NAME']);

    List<Map<String, dynamic>> subtasks =
        List<Map<String, dynamic>>.from(selectedTask['SUBTASKS']);

    subtasks = subtasks.map((e) {
      e['startDateController'] =
          TextEditingController(text: isoToLocalDate(e['STARTDATE']));
      e['endDateController'] =
          TextEditingController(text: isoToLocalDate(e['ENDDATE']));
      e['nameController'] = TextEditingController(text: e['NAME']);
      return e;
    }).toList();
    bool? completed = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return StatsToValidateDetailsDialog(
          selectedTask: selectedTask,
          subTasks: subtasks,
        );
      },
    );
    if (completed != true) return;
    final results = await apiStatsValidateTask(selectedTask['ID']);
    if (results == null) return;
    getUserTasks();
  }

  void onTapValidatedDetails(int index) async {
    final selectedTask = validatedTasks[index];
    List<Map<String, dynamic>> subtasks =
        List<Map<String, dynamic>>.from(selectedTask['SUBTASKS']);
    subtasks = subtasks.map((e) {
      e['startDate'] = isoParseDateTime(e['STARTDATE']);
      e['endDate'] = isoParseDateTime(e['ENDDATE']);
      e['name'] = e['NAME'];
      return e;
    }).toList();
    DateTime minStartDate = getMinStartDate(subtasks);
    DateTime maxEndDate = getMaxEndDate(subtasks);
    Duration maxDuration = maxEndDate.difference(minStartDate);
    int totalTasks = subtasks.length;
    int completedTasks =
        subtasks.where((element) => element['ADVANCE'] == 100).length;
    // Get the reports for the selected task
    final dataMap = {
      'ID': selectedTask['ID'],
    };
    List<Map<String, dynamic>>? reports = await apiStatsGetReports(dataMap);
    if (reports == null) return;
    bool? completed = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return StatsValidatedDetailDialog(
          selectedTask: selectedTask,
          subTasks: subtasks,
          minStartDate: minStartDate,
          maxDuration: maxDuration,
          completedSubTasks: completedTasks,
          nonCompletedSubTasks: totalTasks - completedTasks,
          reports: reports,
        );
      },
    );
    if (completed != true) return;
    final results = await apiStatsCompleteTask(selectedTask['ID']);
    if (results == null) return;
    getUserTasks();
  }

  DateTime getMinStartDate(List<Map<String, dynamic>> subTasks) {
    if (subTasks.isEmpty) return DateTime.now();
    return subTasks.map((e) => e['startDate']).reduce(
        (value, element) => value!.isBefore(element!) ? value : element)!;
  }

  DateTime getMaxEndDate(List<Map<String, dynamic>> subTasks) {
    if (subTasks.isEmpty) return DateTime.now();
    return subTasks.map((e) => e['endDate']).reduce(
        (value, element) => value!.isAfter(element!) ? value : element)!;
  }

  void onTapCompletedDetails(int index) async {
    final selectedTask = completedTasks[index];
    List<Map<String, dynamic>> subtasks =
        List<Map<String, dynamic>>.from(selectedTask['SUBTASKS']);
    subtasks = subtasks.map((e) {
      e['startDate'] = isoParseDateTime(e['STARTDATE']);
      e['endDate'] = isoParseDateTime(e['ENDDATE']);
      e['name'] = e['NAME'];
      return e;
    }).toList();
    DateTime minStartDate = getMinStartDate(subtasks);
    DateTime maxEndDate = getMaxEndDate(subtasks);
    Duration maxDuration = maxEndDate.difference(minStartDate);
    int totalSubTasks = subtasks.length;
    int completedSubTasks =
        subtasks.where((element) => element['ADVANCE'] == 100).length;
    // Get the reports for the selected task
    final dataMap = {
      'ID': selectedTask['ID'],
    };
    List<Map<String, dynamic>>? reports = await apiStatsGetReports(dataMap);
    if (reports == null) return;
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return StatsValidatedDetailDialog(
          selectedTask: selectedTask,
          subTasks: subtasks,
          minStartDate: minStartDate,
          maxDuration: maxDuration,
          completedSubTasks: completedSubTasks,
          nonCompletedSubTasks: totalSubTasks - completedSubTasks,
          reports: reports,
        );
      },
    );
  }

  // TODO: Complete functions
  void onTapToValidateDelete(int index) async {
    final selectedTask = toValidateTasks[index];
    // Show a dialog to confirm the operation
    bool? delete = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('Desea eliminar la tarea: ${selectedTask['NAME']}?'),
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
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (delete != true) return;
    // Delete the task
    final results = await apiStatsDeleteTask(selectedTask['ID']);
    if (results == null) return;
    getUserTasks();
  }

  void onTapToValidateEdit(int index) async {
    final data = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return StatsNewDialog(
            data: toValidateTasks[index],
          );
        });
    if (data == null) return;
    data['ID'] = toValidateTasks[index]['ID'];
    final results = await apiStatsEditTask(data);
    if (results == null) return;
    getUserTasks();
  }

  void onTapValidatedDelete(int index) async {
    final selectedTask = validatedTasks[index];
    // Show a dialog to confirm the operation
    bool? delete = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('Desea eliminar la tarea: ${selectedTask['NAME']}?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: MC_darkblue,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MC_darkblue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (delete != true) return;
    // Delete the task
    final results = await apiStatsDeleteTask(selectedTask['ID']);
    if (results == null) return;
    getUserTasks();
  }

  int? selectedPlotTask;
  List<Map<String, dynamic>> plotSubTasks = [];
  void onChangePlotTask(int? value) async {
    if (selectedPlotTask == value) return;
    selectedPlotTask = value;
    final dataMap = {
      'ID': tasks[selectedPlotTask!]['ID'],
    };
    List<Map<String, dynamic>>? reports = await apiStatsGetReports(dataMap);
    if (reports == null) return;
    plotSubTasks =
        List<Map<String, dynamic>>.from(tasks[selectedPlotTask!]['SUBTASKS']);
    plotSubTasks = plotSubTasks.map((e) {
      e['REPORTS'] = [];
      return e;
    }).toList();
    for (var report in reports) {
      final subTaskIndex = plotSubTasks
          .indexWhere((element) => element['ID'] == report['SUBTASKID']);
      if (subTaskIndex == -1) continue;
      plotSubTasks[subTaskIndex]['REPORTS'].add(report);
    }
    final lastDate = DateTime.now().subtract(const Duration(days: 7));
    for (var subTask in plotSubTasks) {
      int current = 0;
      int last = 0;

      for (var report in subTask['REPORTS']) {
        final createdAt = isoParseDateTime(report['CREATEDAT']);
        final progress = report['PROGRESS'];
        if (createdAt == null) continue;
        if (progress > current) {
          current = progress;
        }
        if (createdAt.isBefore(lastDate)) {
          if (progress > last) {
            last = progress;
          }
        }
      }
      subTask['CURRENT'] = current.toDouble();
      subTask['LAST'] = last.toDouble();
    }
    notifyListeners();
  }

  Map<int, dynamic> ticketCountData = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0};
  final List<String> ticketLabels = ['Seguridad', 'Proyecto', 'Falta', 'Tarea'];

  int get ticketsCount {
    if (ticketCountData.isEmpty) return 0;
    return ticketCountData.values.reduce((value, element) => value + element);
  }

  void getUserTicketCount() async {
    final results = await apiTicketsGetCountUser(dni: selectedUser!['DNI']);
    if (results == null) return;
    ticketCountData =
        results.map((key, value) => MapEntry(int.parse(key), value));
    print(ticketCountData);
    notifyListeners();
  }

  void onTapToUserMode() {
    navigatorKey.currentState!.pushReplacementNamed('/statsuserpage');
  }
}
