import 'dart:io';

import 'package:app_movil_dincydet/api/api_access.dart';
import 'package:app_movil_dincydet/api/api_managedocs.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_received_dialogs.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/src/searchfield.dart';
import 'package:quickalert/quickalert.dart';

class DocumentReceivedProvider extends ChangeNotifier {
  DocumentReceivedProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onTapSearch();
      getOficials();
    });
  }

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController promoterController = TextEditingController();

  int? dependencieValue;
  int? documentType;
  DateTime? startDate;
  DateTime? endDate;

  List<Map<String, dynamic>> documents = [];

  List<Map<String, dynamic>>? access = [];

  void getAccess() async {
    access = await apiAccessAll();
    access ??= [];
  }

  bool get isUserAllowed {
    return Provider.of<MainProvider>(navigatorKey.currentContext!,
            listen: false)
        .accessToManagement;
    // print(userId);
    // List allowedUsers =
    //     access!.where((element) => element['TYPE'] == 'MAN').toList();
    // if (userId == 43377495) return true;
    // return allowedUsers.any((element) => element['USERID'] == userId);
  }

  void onTapAdd() async {
    bool? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentReceivedNewDialog();
        });
    if (complete != true) return;
    onTapSearch();
  }

  void onTapDependencie(SearchFieldListItem<int> p1) {
    dependencieValue = p1.item;
    notifyListeners();
  }

  void onTapStartDate() async {
    // TODO: Show date picker and set date
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

  void onChangeDocType(int? value) {
    documentType = value;
    notifyListeners();
  }

  Future<void> onTapSearch() async {
    final data = await apiDocumentReceivedList(
      startDate?.toIso8601String(),
      endDate?.toIso8601String(),
      documentType,
      dependencieValue,
      documentController.text.isEmpty ? null : documentController.text,
      topicController.text.isEmpty ? null : topicController.text,
    );
    if (data == null) {
      return;
    }
    documents = data;
    notifyListeners();
  }

  void onTapClean() {
    startDate = null;
    endDate = null;
    startDateController.clear();
    endDateController.clear();
    documentController.clear();
    topicController.clear();
    promoterController.clear();
    documentType = null;
    dependencieValue = null;
    onTapSearch();
    notifyListeners();
  }

  void onTapView(int index) async {
    bool? asigned = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentReceivedViewDialog(
            data: documents[index],
            oficials: oficials,
          );
        });
    if (asigned != true) return;
    print('here');
    onTapSearch();
  }

  List<dynamic> oficials = [];

  void getOficials() async {
    Map<String, dynamic>? data = await apiUsersGetOficials();
    if (data == null) return;
    oficials = data['users'];
  }

  void onTapDelete(int i) async {
    // First show a dialog to confirm
    bool? confirm = await QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.confirm,
      title: '¿Estas seguro?',
      onConfirmBtnTap: () =>
          Navigator.of(navigatorKey.currentContext!).pop(true),
    );
    if (confirm != true) return;

    Map<String, dynamic>? data = await apiDocumentDelete(documents[i]['ID']);
    if (data == null) return;
    onTapSearch();
  }

  void onTapEdit(int i) async {
    final document = documents[i];
    File? file;
    if (document['FILE'] != null) {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}\\${document['FILE'].split('/').last}';
      file = File(tempPath);
      file.create();
    }
    bool? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentReceivedNewDialog.edit(
              documentId: document['ID'],
              documentController: document['DOCUMENT'],
              date: DateTime.tryParse(document['DATE']),
              issueController: document['ISSUE'],
              destionationValue: document['DESTINATION'],
              documentType: document['DOCUMENTTYPE'],
              pickedFile: file);
        });
    if (complete != true) return;
    onTapSearch();
  }
}
