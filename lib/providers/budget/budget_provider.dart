import 'dart:convert';

import 'package:app_movil_dincydet/api/api_budget.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/budget/budget_detail.dart';
import 'package:app_movil_dincydet/pages/budget/budget_report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetProvider extends ChangeNotifier {
  BudgetProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onTapSearch();
    });
  }
  final TextEditingController statusController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  int? statusValue;
  DateTime? startDate;
  DateTime? endDate;

  List<String> statusList = [
    'Pendiente',
    'Autorizado',
    'Denegado',
  ];

  void onChangedStatus(int? value) {
    statusValue = value;
    notifyListeners();
  }

  Future<void> onTapSearch() async {
    dynamic parsedStatus = statusValue;
    if (parsedStatus == 0) {
      parsedStatus = "null";
    }
    if (parsedStatus == 1) {
      parsedStatus = true;
    } else if (parsedStatus == 2) {
      parsedStatus = false;
    }
    final data = await apiBudgetList(
      startDate?.toIso8601String(),
      endDate?.toIso8601String(),
      parsedStatus,
    );
    if (data == null) {
      return;
    }
    budgetData = data;
    for (var i = 0; i < budgetData.length; i++) {
      final element = budgetData[i];
      element['ACCEPTBUTTON'] = false;
      element['DENYBUTTON'] = true;
      if (element['STATUS'] != null) element['DENYBUTTON'] = false;
      element['AUTHORIZED'] =
          TextEditingController(text: element['AUTHMONT']?.toString());
      (element['AUTHORIZED'] as TextEditingController)
          .addListener(() => authListener(i));
    }
    notifyListeners();
  }

  void authListener(int index) {
    if (budgetData[index]['STATUS'] != null) return;
    String text = (budgetData[index]['AUTHORIZED'] as TextEditingController)
        .text
        .replaceAll(',', '.');
    double amount = budgetData[index]['AMOUNT'];
    double textAmount = double.tryParse(text) ?? 0;
    if (textAmount == amount) {
      budgetData[index]['ACCEPTBUTTON'] = true;
      budgetData[index]['DENYBUTTON'] = false;
    } else {
      budgetData[index]['ACCEPTBUTTON'] = false;
      budgetData[index]['DENYBUTTON'] = true;
    }
    notifyListeners();
  }

  void onTapClean() {
    statusValue = null;
    startDate = null;
    endDate = null;
    statusController.clear();
    startDateController.clear();
    endDateController.clear();
    onTapSearch();
    notifyListeners();
  }

  void onTapStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: endDate ?? DateTime(2101),
    );
    if (pickedDate == null) {
      return;
    }
    startDate = pickedDate;
    startDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    notifyListeners();
  }

  void onTapEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) {
      return;
    }
    endDate = pickedDate;
    endDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    notifyListeners();
  }

  List<Map<String, dynamic>> budgetData = [];

  void onTapAdd() async {
    // TODO: Complete this part
    bool? complete =
        await navigatorKey.currentState?.pushNamed('/budgetnewpage') as bool?;
    if (complete != true) {
      return;
    }
    onTapClean();
  }

  void onTapExport() async {
    dynamic parsedStatus = statusValue;
    if (parsedStatus == 0) {
      parsedStatus = "null";
    }
    if (parsedStatus == 1) {
      parsedStatus = true;
    } else if (parsedStatus == 2) {
      parsedStatus = false;
    }
    List<Map<String, dynamic>>? items = await apiBudgetDetailedList(
      startDate?.toIso8601String(),
      endDate?.toIso8601String(),
      parsedStatus,
    );
    // Load the Clasificador.json
    String data = await DefaultAssetBundle.of(navigatorKey.currentContext!)
        .loadString('assets/json/Clasificador.json');
    // Decode the json file
    final codesMap = jsonDecode(data);

    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => BudgetReportPage(
          budgetData: items ?? [],
          codesMap: codesMap,
        ),
      ),
    );
  }

  void onTapAccept(int index) async {
    final dataMap = {
      'ID': budgetData[index]['ID'],
      'STATUS': true,
      'AUTHMONT': double.tryParse(
          (budgetData[index]['AUTHORIZED'] as TextEditingController).text),
    };
    final results = await apiBudgetConfirm(dataMap);
    if (results == null) {
      return;
    }
    onTapSearch();
  }

  void onTapReject(int index) async {
    final dataMap = {
      'ID': budgetData[index]['ID'],
      'STATUS': false,
      'AUTHMONT': double.tryParse(
          (budgetData[index]['AUTHORIZED'] as TextEditingController).text),
    };
    final results = await apiBudgetConfirm(dataMap);
    if (results == null) {
      return;
    }
    onTapSearch();
  }

  void onTapDetails(int index) async {
    final items = await apiBudgetItems(budgetData[index]['ID']);
    if (items == null) {
      return;
    }
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return BudgetDetailDialog(
          budgetData: items,
        );
      },
    );
  }
}
