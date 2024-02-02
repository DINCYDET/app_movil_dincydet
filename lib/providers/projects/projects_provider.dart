import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/pages/projects/tasksbottom.dart';
import 'package:app_movil_dincydet/providers/main/mainproject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ProjectsProvider extends ChangeNotifier {
  List<dynamic> prjs = [];
  ProjectsProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateProjects();
    });
  }

  void updateProjects() async {
    Map<String, dynamic>? response = await apiProjectsGetAllDetailed();
    if (response == null) {
      return;
    }
    prjs = response['projects'] as List<dynamic>;
    notifyListeners();
  }

  void onPageChange(int number) {
    notifyListeners();
  }

  void onTapTasks(int index, BuildContext context) async {
    final projectId = prjs[index]['ID'];
    Map<String, dynamic>? data = await apiProjectsGetTasks(projectId);
    if (data == null) {
      return;
    }
    final tooltip = SuperTooltip(
      content: Material(
        child: SizedBox(
          width: min(widthDevice, 400) ,
          child: BottomTaskList(
                  data: data,
                ),
        ),
      ),
      popupDirection: TooltipDirection.down,
    );
    tooltip.show(context);
    /*
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomTaskList(data: response.data);
        });
        */
  }

  void onTapDelete(int prjid) async {
    if (!Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .isAdmin) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('No tienes permiso para realizar esta accion'),
        ),
      );
      return;
    }
    bool? confirmed = await QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.confirm,
      title: 'Confirme la operacion',
      onConfirmBtnTap: () {
        Navigator.of(navigatorKey.currentContext!).pop(true);
      },
    );
    if (confirmed != true) {
      return;
    }
    final dataMap = {
      'prjid': prjid,
    };
    Map<String, dynamic>? results = await apiProjectsDelete(dataMap);
    if (results == null) {
      return;
    }
    updateProjects();
  }

  void onTapNewProject() async {
    bool? complete = await Navigator.pushNamed(
        navigatorKey.currentContext!, '/newprojectpage') as bool?;
    if (complete == true) {
      updateProjects();
    }
  }

  void onTapViewProject(int index) async {
    Provider.of<MainProjectProvider>(navigatorKey.currentContext!,
            listen: false)
        .PRJDATA = prjs[index];
    await Navigator.pushNamed(navigatorKey.currentContext!, '/projectdetail');
    updateProjects();
  }
}
