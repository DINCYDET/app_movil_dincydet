import 'dart:io';
import 'package:app_movil_dincydet/api/api_budget.dart';
import 'package:app_movil_dincydet/api/projects/api_tasks.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/pages/budget/budget_detail.dart';
import 'package:app_movil_dincydet/pages/projects/dialogs/project_edit.dart';
import 'package:app_movil_dincydet/pages/projects/dialogs/project_progress.dart';
import 'package:app_movil_dincydet/pages/projects/dialogs/ticketsprojecttable.dart';
import 'package:app_movil_dincydet/pages/projects/project_inventory.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainproject_provider.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:dio/dio.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:screenshot/screenshot.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProjectDetailProvider extends ChangeNotifier {
  String name = Provider.of<MainProjectProvider>(navigatorKey.currentContext!,
          listen: false)
      .PRJDATA!['NAME'];
  int prjid = Provider.of<MainProjectProvider>(navigatorKey.currentContext!,
          listen: false)
      .PRJDATA!['ID'];
  Map<String, dynamic> data = {'tasks': []};

  ProjectDetailProvider() {
    loadProjectData();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllUsers();
      updateTasks();
      getProjectFiles();
      updateDetails();
      getAllMembers();
      updateBudget();
      getProjectsList();
    });
  }

  void loadProjectData() {
    final prjdata = Provider.of<MainProjectProvider>(
            navigatorKey.currentContext!,
            listen: false)
        .PRJDATA;
    nameController.text = prjdata!['NAME'] ?? '';
    final navalForceId = prjdata['NAVALFORCEID'];
    if (navalForceId != null) {
      navalForceController.text =
          dependencies.elementAtOrNull(navalForceId) ?? '';
    }
    startDateController.text =
        prjdata['STARTDATE'] ?? ''; //isoToLocalDate(prjdata['STARTDATE']);
    endDateController.text =
        prjdata['ENDDATE'] ?? ''; //isoToLocalDate(prjdata['ENDDATE']);
    descriptionController.text = prjdata['DESCRIPTION'] ?? '';
    userNameController.text = prjdata['LEADNAME'] ?? '';
    advance = prjdata['ADVANCE'] ?? 0;
  }

  // ------ SECTION CODE FOR MEMBERS
  List<SelectedListItem> users = [];
  final TextEditingController pickedUserController = TextEditingController();
  List<dynamic> members = [];
  Set membersDNI = {};
  int? selectedUser;
  void onTapDeleteMember(int index) async {
    final thismember = members[index];
    final dataMap = {
      'prjid': prjid,
      'userid': thismember['USERID'],
    };
    final results = await apiMembersDelete(dataMap);
    if (results == null) return;
    if (results['sucess'] != true) {
      QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.warning,
        title: 'Operacion fallida',
        text: results['message'] ?? 'No se elimino el usuario del proyecto',
      );
      return;
    }
    getAllMembers();
    membersDNI.remove(thismember['dni']);
    notifyListeners();
  }

  void getAllUsers() async {
    Map<String, dynamic>? data = await apiUsersGetAll();
    if (data == null) {
      return;
    }
    // TODO: add users to users list
    users = data['users']
        .map<SelectedListItem>(
          (e) => SelectedListItem(
            value: e['DNI'].toString(),
            name: e['FULLNAME'],
          ),
        )
        .toList();
  }

  void onTapAddMember() async {
    if (selectedUser == null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un usuario'),
        ),
      );
      return;
    }
    final dataMap = {
      'prjid': prjid,
      'userid': selectedUser,
    };
    Map<String, dynamic>? data = await apiMembersAdd(dataMap);
    if (data == null) {
      return;
    }
    selectedUser = null;
    pickedUserController.text = '';
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      title: 'Se ha agregado el usuario al proyecto',
      type: QuickAlertType.success,
    );
    getAllMembers();
  }

  void onTapUser() {
    List<SelectedListItem> nonMembers = [];
    for (var user in users) {
      if (!membersDNI.contains(int.parse(user.value!))) {
        nonMembers.add(user);
      }
    }
    DropDownState(
      DropDown(
        bottomSheetTitle: const Text('Usuarios'),
        data: nonMembers,
        selectedItems: (items) {
          for (SelectedListItem item in items) {
            selectedUser = int.parse(item.value!);
            pickedUserController.text = item.name;
            notifyListeners();
            return;
          }
        },
      ),
    ).showModal(navigatorKey.currentContext!);
  }

  void getAllMembers() async {
    final dataMap = {
      'prjid': prjid,
    };
    Map<String, dynamic>? data = await apiMembersGetAll(dataMap);
    if (data == null) {
      return;
    }
    members = data['members'];
    for (var member in members) {
      membersDNI.add(member['dni']);
    }
    notifyListeners();
  }

  // ------ SECTION CODE FOR FILES

  // ------ SECTION CODE FOR PROJECT DATA
  final TextEditingController nameController = TextEditingController();
  final TextEditingController navalForceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  int managerid = 0;

  void updateTasks() async {
    Map<String, dynamic>? results = await apiProjectsGetTasks(prjid);
    if (results == null) {
      return;
    }
    data['tasks'] = results['tasks'];
    // Code to update the chart
    DateFormat formato = DateFormat("dd-MM-yyyy");
    DateTime maxdate = DateTime.now();
    DateTime mindate = DateTime.now();
    int counter = 0;
    final mainColor = Colors.blue.shade200;
    final secondColor = Colors.grey.shade300;
    events = [];
    for (var task in data['tasks']) {
      var startdate = formato.parse(task['STARTDATE']);
      var enddate = formato.parse(task['ENDDATE']);
      if (enddate.isAfter(maxdate)) {
        maxdate = enddate;
      }
      if (startdate.isBefore(mindate)) {
        mindate = startdate;
      }
      events.add(
        GanttAbsoluteEvent(
          startDate: startdate,
          endDate: enddate,
          displayName: task['NAME'],
          suggestedColor: counter % 2 == 0 ? mainColor : secondColor,
        ),
      );
      counter++;
      for (var subtask in task['SUBTASKS']) {
        var startdate2 = formato.parse(subtask['STARTDATE']);
        var enddate2 = formato.parse(subtask['ENDDATE']);
        if (enddate2.isAfter(maxdate)) {
          maxdate = enddate2;
        }
        if (startdate2.isBefore(mindate)) {
          mindate = startdate2;
        }
        events.add(
          GanttAbsoluteEvent(
            startDate: startdate2,
            endDate: enddate2,
            displayName: subtask['NAME'],
            suggestedColor: counter % 2 == 0 ? mainColor : secondColor,
          ),
        );
        counter++;
      }
    }
    ganttDuration = maxdate.difference(mindate);
    ganttStartDate = mindate;
    notifyListeners();
  }

  // Detalles de proyecto
  Map<String, dynamic> tdata = {'OPEN': 0, 'PROCESS': 0, 'CLOSE': 0};
  int get totaltickets => tdata['OPEN'] + tdata['CLOSE'] + tdata['PROCESS'];
  String startdate = '';
  String enddate = '';
  int days = 0;
  int advance = 0;

  void updateDetails() async {
    Map<String, dynamic>? response = await apiProjectsGetDetails(prjid);
    if (response == null) {
      return;
    }
    tdata = response['TICKETS'];
    final totaltickets = tdata['OPEN'] + tdata['CLOSE'] + tdata['PROCESS'];
    if (totaltickets == 0) {
      tdata['CLOSE'] = 1;
    }
    notifyListeners();
  }

  void onpushEdit() async {
    int? result =
        await Navigator.pushNamed(navigatorKey.currentContext!, '/editproject')
            as int?;
    if (result != null) {
      advance = result;
      updateTasks();
    }
  }

  // CODE FOR FILES
  List<dynamic> filesdata = [];
  Map<ProjectFileType, List<dynamic>> files = {
    ProjectFileType.image: [],
    ProjectFileType.video: [],
    ProjectFileType.info: [],
    ProjectFileType.txt: [],
  };

  void getProjectFiles() async {
    Map<String, dynamic>? data = await apiProjectsGetFiles(prjid);
    if (data == null) {
      return;
    }
    files[ProjectFileType.image] = data['images'];
    files[ProjectFileType.video] = data['videos'];
    files[ProjectFileType.info] = data['info'];
    files[ProjectFileType.txt] = data['txt'];
    notifyListeners();
  }

  void onTapAdd(ProjectFileType pft) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      //File file = File(result.files.single.path!);
      final dataMap = FormData.fromMap({
        'ID': prjid,
        'TYPE': pft.index,
        'files': await MultipartFile.fromFile(result.files.single.path!),
      });
      Map<String, dynamic>? data = await apiProjectsAddFile(dataMap);
      if (data == null) {
        return;
      }
      getProjectFiles();
    } else {
      return;
    }
  }

  void onTapTickets() async {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => TicketsProjectTable(
        prjid: prjid,
      ),
    );
  }

  void onTapDeleteFile(int itemid) async {
    bool complete = false;
    await QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.confirm,
      title: 'Confirme la operacion',
      onConfirmBtnTap: () {
        complete = true;
        navigatorKey.currentState!.pop();
      },
    );
    if (!complete) {
      return;
    }
    final dataMap = {
      'fileid': itemid,
    };
    Map<String, dynamic>? response = await apiProjectsFileDelete(dataMap);
    if (response == null) {
      return;
    }
    getProjectFiles();
  }

  bool ganttSelected = false;
  void onTapGeneralTasks() {
    if (!ganttSelected) {
      return;
    }
    ganttSelected = false;
    notifyListeners();
  }

  List<GanttAbsoluteEvent> events = <GanttAbsoluteEvent>[];
  DateTime ganttStartDate = DateTime.now();
  Duration ganttDuration = const Duration(days: 30);
  void onTapGanttTasks() {
    if (ganttSelected) {
      return;
    }
    ganttSelected = true;
    notifyListeners();
  }

  //FIXME: Optimize code gor gantt chart
  void onTapExportGantt() async {
    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory == null) {
      return;
    }
    String filename = "$directory/Gantt-${nameController.text}";
    ScreenshotController screenshotController = ScreenshotController();
    double width = ganttDuration.inDays * 30 + 200 + 20;
    double height = 40 + 30 + events.length * 75 + 20;
    Widget ganttWidget = MediaQuery(
      data: const MediaQueryData(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: GanttChartView(
                  showDays: true,
                  eventHeight: 75,
                  stickyAreaEventBuilder:
                      (context, eventIndex, event, eventColor) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: eventColor,
                        border: Border.all(),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.displayName!,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  showStickyArea: true,
                  startOfTheWeek: WeekDay.monday,
                  weekEnds: const {
                    WeekDay.saturday,
                    WeekDay.sunday,
                  },
                  maxDuration: ganttDuration,
                  events: events,
                  startDate: ganttStartDate,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Uint8List imgdata = await screenshotController.captureFromWidget(
      ganttWidget,
      targetSize: Size(width, height),
    );

    // Generacion del pdf
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.undefined,
        ),
        build: (context) {
          return pw.Center(
            child: pw.Image(
              pw.MemoryImage(imgdata),
            ),
          );
        },
      ),
    );
    File thisfile = File("$filename.pdf");
    await thisfile.create();
    await thisfile.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Diagrama de Gantt generado'),
      ),
    );
  }

  void onTapEditData() async {
    final Map<String, dynamic>? dataMap = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return ProjectEditDialog(
            name: nameController.text,
            description: descriptionController.text,
            startDate: startDateController.text,
            endDate: endDateController.text,
            projectManagerName: userNameController.text,
            users: users,
            navalForce: navalForceController.text,
          );
        });
    if (dataMap == null) return;
    dataMap['ID'] = prjid;
    Map<String, dynamic>? response = await apiProjectsEditDetails(dataMap);
    if (response == null) {
      return;
    }
    nameController.text = dataMap['NAME'];
    descriptionController.text = dataMap['DESCRIPTION'];
    if (dataMap['LEADNAME'] != null) {
      userNameController.text = dataMap['LEADNAME'];
    }
    if (dataMap['NAVALFORCENAME'] != null) {
      navalForceController.text = dataMap['NAVALFORCENAME'];
    }
    getAllMembers();
    notifyListeners();
  }

  List<Map<String, dynamic>> projectsList = [
    {
      "NAME": "DINCYDET",
      "ID": -1,
    }
  ];

  void getProjectsList() async {
    final projects = await apiProjectsGetList();
    if (projects != null) {
      projectsList.addAll(projects);
    }
  }

  void onTapInventory() async {
    final List<Map<String, dynamic>>? items =
        await apiProjectsGetInventoryItems(prjid);
    if (items == null) return;
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return ProjectInventoryDialog(
          data: items,
          projectsList: projectsList,
        );
      },
    );
  }

  // Code for budget
  List<Map<String, dynamic>> budgetData = [];

  void updateBudget() async {
    List<Map<String, dynamic>>? response = await apiProjectsGetBudgets(prjid);
    if (response == null) {
      return;
    }
    budgetData = response;
    notifyListeners();
  }

  void onTapBudgetDetails(int index) async {
    final items = await apiBudgetItems(budgetData[index]['ID']);
    if (items == null) {
      return;
    }
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return BudgetDetailDialog(budgetData: items);
      },
    );
  }

  int currentUserId =
      Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
          .USERDATA!['DNI'];

  void onTapSetTask(int taskId, int userId, int taskAdvance) async {
    if (userId != currentUserId) {
      // Show message that you can't set task for other users
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No puedes editar tareas de otros usuarios'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
    double? value = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return ProjectProgressDialog(
          isTask: true,
          initialValue: taskAdvance.toDouble(),
        );
      },
    );
    if (value == null) return;
    final results = await apiTasksSetAdvance(taskId, value.toInt());
    if (results == null) return;
    advance = results['advance'];
    notifyListeners();
    updateTasks();
  }

  void onTapSetSubTask(int subTaskId, int userId, int advance) async {
    if (userId != currentUserId) {
      // Show message that you can't set task for other users
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No puedes editar subtareas de otros usuarios'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
    double? value = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return ProjectProgressDialog(
          isTask: false,
          initialValue: advance.toDouble(),
        );
      },
    );
    if (value == null) return;
    final results = await apiSubtasksSetAdvance(subTaskId, value.toInt());
    if (results == null) return;
    updateTasks();
  }

  void onTapComplete() async {
    if (advance != 100) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'No puedes completar un proyecto que no está al 100%'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: MC_darkblue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
    // Show message to confirm completion
    bool? completed = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Está seguro que desea completar el proyecto?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: MC_darkblue,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
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
              child: const Text('Completar'),
            ),
          ],
        );
      },
    );
    if (completed != true) return;
    final results = await apiProjectsComplete(prjid);
    if (results == null) return;
    Navigator.pop(navigatorKey.currentContext!);
  }
}

// enum for fileTypes start from 0
enum ProjectFileType {
  image,
  video,
  info,
  txt,
}
