import 'package:app_movil_dincydet/api/api_managedocs.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_asign_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class DocumentAssignProvider extends ChangeNotifier {
  DocumentAssignProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onTapSearch();
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

  void onTapView(int index) async {
    bool? asigned = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentAssignedViewDialog(
            data: documents[index],
          );
        });
    if (asigned != true) return;
    onTapSearch();
  }

  bool pending = true;
  void onTapType() {
    pending = !pending;
    onTapSearch();
    notifyListeners();
  }

  String get typeText =>
      pending ? 'Documentos\nPendientes' : 'Documentos\nEjecutados';
  Color get typeColor => pending ? Colors.red : Colors.green;

  void onTapDependencie(SearchFieldListItem<int> p1) {
    dependencieValue = p1.item;
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

  void onChangeDocType(int? value) {
    documentType = value;
    notifyListeners();
  }

  Future<void> onTapSearch() async {
    final data = await apiDocumentsAssignedList(
        startDate?.toIso8601String(),
        endDate?.toIso8601String(),
        documentType,
        dependencieValue,
        documentController.text.isEmpty ? null : documentController.text,
        topicController.text.isEmpty ? null : topicController.text,
        pending);
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
    notifyListeners();
    onTapSearch();
  }
}
