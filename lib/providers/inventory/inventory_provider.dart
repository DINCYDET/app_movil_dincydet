import 'dart:io';

import 'package:app_movil_dincydet/api/api_inventory.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_detail.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_dialogs.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:searchfield/searchfield.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InventoryProvider extends ChangeNotifier {
  InventoryProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onTapSearch();
      getProjectsList();
    });
  }

  final TextEditingController ibpController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final TextEditingController itemTypeController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController projectController = TextEditingController();

  int? projectID;
  int? projectOnlyID;
  int? objectType;
  int? locationValue;

  DateTime? startDate;
  DateTime? endDate;

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

  bool isList = true;

  void onTapAdd() async {
    bool? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return InventoryNewDialog(
            projectsList: projectsList,
          );
        });
    if (complete == null) {
      return;
    }
    onTapSearch();
  }

  void onTapChange() {
    isList = !isList;
    notifyListeners();
  }

  List<Map<String, dynamic>> inventoryData = [];
  List<Map<String, dynamic>>? originData;

  List<Map<String, dynamic>>? locationData;

  List<Map<String, dynamic>> projectsList = [
    {
      "NAME": "DINCYDET",
      "ID": -1,
    }
  ];

  List<Map<String, dynamic>> projectOnlyList = [];

  void getProjectsList() async {
    final projects = await apiProjectsGetList();
    if (projects != null) {
      projectsList.addAll(projects);
      projectOnlyList.addAll(projects);
      notifyListeners();
    }
  }

  void onTapClean() {
    ibpController.clear();
    locationController.clear();
    startDateController.clear();
    endDateController.clear();
    itemTypeController.clear();
    originController.clear();
    projectController.clear();
    projectID = null;
    projectOnlyID = null;
    objectType = null;
    locationValue = null;
    startDate = null;
    endDate = null;
    onTapSearch();
    notifyListeners();
  }

  void onTapCleanPlot() {
    originController.clear();
    itemTypeController.clear();
    objectType = null;
    projectID = null;
    locationValue = null;
    notifyListeners();
  }

  Future<void> onTapSearch() async {
    final results = await apiInventoryGetAll(
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      origin: projectID,
      project: projectOnlyID,
      location: locationValue,
      itemType: objectType,
      ibp: ibpController.text.isEmpty ? null : ibpController.text,
    );
    if (results == null) return;
    inventoryData = results;
    notifyListeners();
  }

  void onTapPlot() async {
    final results = await apiInventoryGetCountPlot(
      objectType,
      projectID,
      locationValue,
    );
    if (results == null) return;
    final origin = results['ORIGIN'];
    if (origin == null) {
      originData = null;
    } else {
      originData = [];
      for (var element in origin) {
        originData!.add({
          'title': inventoryTypes[element['index']],
          'color': Colors.primaries[element['index'] % Colors.primaries.length],
          'value': element['value'],
        });
      }
    }
    final location = results['LOCATION'];
    if (location == null) {
      locationData = null;
    } else {
      locationData = [];
      for (var element in location) {
        locationData!.add({
          'title': inventoryTypes[element['index']],
          'color': Colors.primaries[element['index'] % Colors.primaries.length],
          'value': element['value'],
        });
      }
    }
    notifyListeners();
  }

  void onTapType(SearchFieldListItem<int> p1) {
    if (p1.item == objectType) return;
    objectType = p1.item;
    notifyListeners();
  }

  void onTapProject(SearchFieldListItem<int> p1) {
    if (p1.item == projectID) return;
    projectID = p1.item;
    notifyListeners();
  }

  void onTapProjectOnly(SearchFieldListItem<int> p1) {
    if (p1.item == projectOnlyID) return;
    projectOnlyID = p1.item;
    notifyListeners();
  }

  void onChangedLocation(int? value) {
    if (value == locationValue) return;
    locationValue = value;
    notifyListeners();
  }

  void onTapDelete(int index) async {
    // Show a dialog to confirm the deletion
    final confirmation = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Eliminar'),
            content: const Text(
                '¿Está seguro que desea eliminar el elemento seleccionado?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Eliminar'),
              ),
            ],
          );
        });
    if (confirmation == null || !confirmation) return;
    final result = await apiInventoryDelete(inventoryData[index]['ID']);
    if (result == null) return;
    inventoryData.removeAt(index);
    notifyListeners();
  }

  void onTapDetail(int index) async {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return InventoryDetailDialog(
            projectsList: projectsList,
            data: inventoryData[index],
          );
        });
  }

  void onTapEdit(int index) async {
    bool? edited = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return InventoryDetailDialog(
            projectsList: projectsList,
            data: inventoryData[index],
            editable: true,
          );
        });
    if (edited == true) {
      onTapSearch();
    }
  }

  // Code for report
  final ScreenshotController screenshotController = ScreenshotController();
  void onTapExport() async {
    // Save the image screenshot as pdf
    final imageFile = await screenshotController.capture();
    if (imageFile == null) return;
    // Save the pdf file
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.undefined,
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(imageFile),
          ); // Center
        },
      ),
    );
    // Save the file
    final filePath = await FilePicker.platform.saveFile(
      allowedExtensions: ['pdf'],
      fileName: 'inventory.pdf',
      lockParentWindow: true,
    );
    if (filePath == null) return;
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }
}
