import 'package:app_movil_dincydet/api/api_documents.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/documents/documents_detail.dart';
import 'package:app_movil_dincydet/pages/documents/documents_dialogs.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocumentsProvider extends ChangeNotifier {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  int? stageValue;

  int? myUserDNI =
      Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
          .USERDATA?['DNI'];

  List<Map<String, dynamic>> persubaUsers = [];
  List<Map<String, dynamic>> documents = [];

  // List of stages(const)
  final List<String> stages = [
    'Pendiente',
    'En Proceso',
    'Archivado',
  ];

  DocumentsProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initProvider();
    });
  }
  void initProvider() async {
    getPersubaUsers();
    onTapSearch();
  }

  void onChangedStage(int? value) {
    stageValue = value;
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

  Future<void> onTapSearch() async {
    final List<Map<String, dynamic>>? data = await apiDocumentsGetAll(
      startDate: startDate,
      endDate: endDate,
      stage: stageValue,
      isIn: !send,
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
    stageValue = null;
    startDateController.clear();
    endDateController.clear();
    notifyListeners();
    onTapSearch();
  }

  void getPersubaUsers() async {
    Map<String, dynamic>? data = await apiUsersGetPersuba();
    if (data == null) {
      return;
    }
    persubaUsers = List<Map<String, dynamic>>.from(data['users']);
    print(persubaUsers);

    notifyListeners();
  }

  void onTapAdd() async {
    Map<String, dynamic>? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentNewDialog(
            persubaUsers: persubaUsers,
          );
        });
    if (complete == null) {
      return;
    }
    Map<String, dynamic>? data = await apiDocumentsAdd(complete);
    if (data == null) {
      return;
    }
    if (data['results'] != true) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                  data['message'] ?? 'No se ha podido añadir el documento'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'))
              ],
            );
          });
      return;
    }
    onTapSearch();
  }

  bool send = false;

  void onTapSended() {
    send = !send;
    onTapSearch();
    notifyListeners();
  }

  void onTapDetail(int index) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentDetailDialog(
            persubaUsers: persubaUsers,
            documentData: documents[index],
          );
        });
  }

  void onTapAuth(int index, bool value, int authIndex) async {
    Map<String, dynamic>? data = await apiDocumentsValidate(
      documents[index]['ID'],
      value,
      authIndex,
    );
    if (data == null) {
      return;
    }
    onTapSearch();
  }
}
