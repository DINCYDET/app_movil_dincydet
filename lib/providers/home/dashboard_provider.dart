import 'dart:async';

import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/api/api_dashboard.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateAssistanceData();
      updateAssistancePartData();
      updateSuggestions();
      subscribeToGIS();
      subscribeToAssistance();
      updateVisits();
      getTicketSummary();
    });
  }

  bool mounted = true;

  @override
  void notifyListeners() {
    if (mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    mounted = false;
    gisStream?.cancel();
    assistanceStream?.cancel();
    super.dispose();
  }

  Map<String, dynamic> assistanceData = {};
  Map<String, dynamic> assistancePartData = {};

  int get assistancePartTotal {
    int total = 0;
    for (var item in assistancePartData.values) {
      total += item as int;
    }
    return total;
  }

  void updateAssistanceData() async {
    Map<String, dynamic>? response = await apiAssistanceGetAll();
    if (response == null) return;
    assistanceData = response;
    notifyListeners();
  }

  void updateAssistancePartData() async {
    Map<String, dynamic>? response = await apiAssistancePartGetAll();
    if (response == null) return;
    assistancePartData = response;
    notifyListeners();
  }

  int? alertType;
  void onChangeAlertType(int? value) {
    if (alertType == value) return;
    alertType = value;
    notifyListeners();
  }

  void onTapAlert() async {
    if (alertType == null) {
      return;
    }
    Map<String, dynamic>? response = await apiAlertsSend(alertType!);

    if (response == null) {
      return;
    }
    if (response['success'] != true) {
      QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.warning,
        title: 'Se envio la alerta',
        text: response['message'] ??
            'Es probable que algunos dispositivos no hayan recibido la alerta',
        barrierDismissible: true,
      );
      return;
    }
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.success,
      text: 'Alerta enviada',
      barrierDismissible: true,
    );
  }

  void onTapCall() async {
    int? userid;
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
        selectedItems: (List<dynamic> selectedList) async {
          for (var item in selectedList) {
            userid = int.parse(item.value);
            if (userid == null) return;
            doCallTask(userid!);
            break;
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(navigatorKey.currentContext!);
  }

  void doCallTask(int userid) async {
    Map<String, dynamic>? response = await apiAlertsCall(userid);
    if (response == null) {
      return;
    }
    if (response['success'] != true) {
      QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.warning,
        title: 'Ocurrio un problema',
        text: response['message'] ?? 'No se pudo realizar la llamada',
        barrierDismissible: true,
      );
    } else {
      QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.success,
        text: 'Notificacion enviada',
        barrierDismissible: true,
      );
    }
  }

  // Actualizar sugerencias
  List<SelectedListItem> suggestions = <SelectedListItem>[];

  void updateSuggestions() async {
    Map<String, dynamic>? response = await apiUsersGetAll();
    if (response == null) {
      return;
    }
    final users = response['users'] as List<dynamic>;
    suggestions = users.map((e) {
      return SelectedListItem(
          name: e['FULLNAME'], value: e['DNI'].toString(), isSelected: false);
    }).toList();
    notifyListeners();
  }

  //For GIS an socket events
  Map<int, dynamic> gisData = {};

  StreamSubscription? gisStream;
  void subscribeToGIS() {
    gisStream =
        Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
            .GISupdateStream
            .listen(
      (event) {
        updateVisits();
      },
    );
  }

  StreamSubscription? assistanceStream;
  void subscribeToAssistance() {
    assistanceStream =
        Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
            .AssistanceStream
            .listen(
      (event) {
        updateAssistanceData();
        updateAssistancePartData();
      },
    );
  }

  void updateVisits() async {
    Map<String, dynamic>? response = await apiAssistanceVisits();
    if (response == null) {
      return;
    }
    List<dynamic> data = response['visits'];
    update(data);
    notifyListeners();
  }

  // Update the data for the GIS
  void update(List<dynamic> data) {
    Map<int, dynamic> tempData = {};
    for (var element in data) {
      if (tempData.containsKey(element['IDPOS'])) {
        ((tempData[element['IDPOS']] as Map<String, dynamic>)['images'] as List)
            .add(element['USER']['PHOTO']);
        ((tempData[element['IDPOS']] as Map<String, dynamic>)['ids'] as List)
            .add(element['USER']['DNI']);
      } else {
        tempData[element['IDPOS']] = {
          'xpos': element['XPOS'].toDouble(),
          'ypos': element['YPOS'].toDouble(),
          'images': [element['USER']['PHOTO']],
          'ids': [element['USER']['DNI']]
        };
      }
    }
    gisData = tempData;
    notifyListeners();
  }

  void onTapEfectives() {
    navigatorKey.currentState!.pushNamed('/assistancepage');
  }

  // Resumen de tickets
  bool sChart = false;
  bool eChart = false;
  bool rChart = false;
  Map<dynamic, dynamic> tsummary = {
    'all': {"0": 0, "1": 0, "2": 0, "3": 0},
    'emitted': {"0": 0, "1": 0, "2": 0, "3": 0},
    'received': {"0": 0, "1": 0, "2": 0, "3": 0},
  };
  void getTicketSummary() async {
    Map<String, dynamic>? results = await apiTicketsSummary();
    if (results == null) {
      return;
    }
    results = results['summary'];
    if (results == null) {
      return;
    }
    for (var key in (results['all'] as Map<dynamic, dynamic>).keys) {
      var value = results['all'][key];
      if (!sChart && value != 0) {
        sChart = true;
      }
      tsummary['all'][key] = value;
    }
    for (var key in (results['emitted'] as Map<dynamic, dynamic>).keys) {
      var value = results['emitted'][key];
      if (!eChart && value != 0) {
        eChart = true;
      }
      tsummary['emitted'][key] = value;
    }
    for (var key in (results['received'] as Map<dynamic, dynamic>).keys) {
      var value = results['received'][key];
      if (!rChart && value != 0) {
        rChart = true;
      }
      tsummary['received'][key] = value;
    }
    notifyListeners();
  }

  void onTapToPersonal() {
    navigatorKey.currentState!.pushNamed('/personalpage');
  }
}
