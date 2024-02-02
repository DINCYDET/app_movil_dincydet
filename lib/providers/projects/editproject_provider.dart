import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/tasks_subtasks_class.dart';
import 'package:app_movil_dincydet/providers/main/mainproject_provider.dart';
import 'package:app_movil_dincydet/providers/projects/addonproject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProjectProvider extends ChangeNotifier {
  late AddonProjectProvider addonprovider;
  int prjid = Provider.of<MainProjectProvider>(navigatorKey.currentContext!,
          listen: false)
      .PRJDATA!['ID'];
  EditProjectProvider() {
    addonprovider = AddonProjectProvider(prjid);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateProjectTasks();
    });
  }

  void onTapRegister() async {
    for (TaskData task in addonprovider.tasks) {
      if (!task.isfilled()) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Complete todos los campos de tareas'),
          ),
        );
        return;
      }
    }
    for (List<SubTaskData> subtasks in addonprovider.subtasks) {
      for (SubTaskData subtask in subtasks) {
        if (!subtask.isfilled()) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Text('Complete todos los campos de subtareas'),
            ),
          );
          return;
        }
      }
    }
    // Generamos el payload
    final List<Map<String, dynamic>> tasks =
        addonprovider.tasks.map((e) => e.asMap()).toList();
    final List<List<Map<String, dynamic>>> subtasks =
        addonprovider.subtasks.map(
      (pstasks) {
        return pstasks.map((e) => e.asMap()).toList();
      },
    ).toList();
    final Map<String, dynamic> dataMap = {
      'ID': prjid,
      'tasks': tasks,
      'subtasks': subtasks,
      'taskids': taskids,
      'subtaskids': subtaskids,
    };

    final Map<String, dynamic>? data = await apiProjectsEdit(dataMap);
    if (data == null) {
      return;
    }
    int? mean = data['advance'];

    Navigator.of(navigatorKey.currentContext!).pop(mean);
  }

  List<int> taskids = [];
  List<int> subtaskids = [];

  void updateProjectTasks() async {
    Map<String, dynamic>? data = await apiProjectsGetTasks(prjid);
    if (data == null) {
      return;
    }
    final tasks = data['tasks'];
    addonprovider.tasks = List.generate(tasks.length, (i) {
      final thistask = tasks[i];
      TaskData td = TaskData();
      td.name.text = thistask['NAME'];
      td.start.text = thistask['STARTDATE'];
      td.end.text = thistask['ENDDATE'];
      td.username.text = thistask['USERDATA']['FULLNAME'];
      td.userid = thistask['USERDATA']['DNI'];
      td.taskid = thistask['ID'];
      taskids.add(thistask['ID']);
      final subtasks =
          List<SubTaskData>.generate(thistask['SUBTASKS'].length, (j) {
        final thissubtask = thistask['SUBTASKS'][j];
        SubTaskData std = SubTaskData();
        std.name.text = thissubtask['NAME'];
        std.start.text = thissubtask['STARTDATE'];
        std.end.text = thissubtask['ENDDATE'];
        std.username.text = thissubtask['USERDATA']['FULLNAME'];
        std.userid = thissubtask['USERDATA']['DNI'];
        std.subtaskid = thissubtask['ID'];
        subtaskids.add(thissubtask['ID']);
        return std;
      });
      addonprovider.subtasks.add(subtasks);
      return td;
    });
    notifyListeners();
    addonprovider.notifyListeners();
  }
}
