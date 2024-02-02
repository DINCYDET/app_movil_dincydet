import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/tasks_subtasks_class.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class AddonProjectProvider extends ChangeNotifier {
  final int prjid;
  List<TaskData> tasks = <TaskData>[];
  List<List<SubTaskData>> subtasks = <List<SubTaskData>>[];
  List<SelectedListItem> suggestions = <SelectedListItem>[];

  AddonProjectProvider(this.prjid) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateSuggestions();
    });
  }

  void addTask() {
    tasks.add(TaskData());
    subtasks.add([]);
    notifyListeners();
  }

  void removeTask(int i) {
    tasks.removeAt(i);
    subtasks.removeAt(i);
    notifyListeners();
  }

  void addSubTask(int i) {
    subtasks[i].add(SubTaskData());
    notifyListeners();
  }

  void removeSubTask(int i, int j) {
    subtasks[i].removeAt(j);
    notifyListeners();
  }

  void updateSuggestions() async {
    Map<String, dynamic>? response = await apiProjectsGetUsers(prjid);
    if (response == null) {
      return;
    }
    final users = response['users'] as List<dynamic>;
    suggestions = users.map((e) {
      return SelectedListItem(
        name: e['USERDATA']['FULLNAME'],
        value: e['USERDATA']['DNI'].toString(),
        isSelected: false,
      );
    }).toList();
    notifyListeners();
  }
}
