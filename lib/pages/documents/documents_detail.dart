import 'dart:convert';
import 'dart:io';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DocumentDetailDialog extends StatefulWidget {
  const DocumentDetailDialog({
    super.key,
    required this.persubaUsers,
    required this.documentData,
  });
  final List<Map<String, dynamic>> persubaUsers;
  final Map<String, dynamic> documentData;
  @override
  State<DocumentDetailDialog> createState() => _DocumentDetailDialogState();
}

class _DocumentDetailDialogState extends State<DocumentDetailDialog> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController toUserController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  int value = 0;
  int? persubaUserValue;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? date;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  File? pickedFile;

  @override
  void initState() {
    value = widget.documentData['TYPE'];
    descriptionController.text = widget.documentData['DESCRIPTION'];
    loadJsonFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(15.0),
      title: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF073264),
        ),
        child: Row(
          children: [
            const Spacer(),
            Text(
              'Papeleta de Autorización Nº $getDocumentNumber',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            children: [
              // Dropdown to select the type of document
              DropdownButtonFormField<int>(
                value: value,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Papeleta',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(documentTypes.length, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text(documentTypes[index]),
                  );
                }),
                onChanged: null,
              ),

              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: descriptionController,
                label: 'Descripción',
                minLines: 4,
                maxLines: 4,
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                    visible: isVacations || isCommission || isChangeGuard,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Inicio',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: startDateController,
                      onTap: null,
                    ),
                  ),
                  Visibility(
                    visible: isVacations || isCommission || isChangeGuard,
                    child: const SizedBox(
                      height: 10,
                    ),
                  ),
                  Visibility(
                    visible: isVacations || isCommission || isChangeGuard,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Fin',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: endDateController,
                      onTap: null,
                    ),
                  ),
              Visibility(
                visible: isPermission || isAudience,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: dateController,
                  onTap: null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isVacations,
                    child: const Text('Total Días:'),
                  ),
                  Visibility(
                    visible: isVacations,
                    child: const SizedBox(
                      width: 20,
                    ),
                  ),
                  Visibility(
                    visible: isVacations,
                    child: SizedBox(
                      width: 80,
                      child: MyTextField(
                        label: 'Dias',
                        readOnly: true,
                        controller: daysController,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isPermission || isCommission,
                    child: Expanded(
                      child: MyTextField(
                        label: 'Hora Inicio',
                        readOnly: true,
                        onTap: null,
                        prefix: const Icon(Icons.access_time),
                        controller: startTimeController,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isPermission || isCommission,
                    child: const SizedBox(
                      width: 20,
                    ),
                  ),
                  Visibility(
                    visible: isPermission || isCommission,
                    child: Expanded(
                      child: MyTextField(
                        label: 'Hora Fin',
                        readOnly: true,
                        onTap: null,
                        prefix: const Icon(Icons.access_time),
                        controller: endTimeController,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isChangeGuard,
                    child: Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Aceptante',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        controller: userController,
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  label: Text('Archivo Adjunto'),
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: onTapDownloadFile,
                  child: Text(
                    uploadedFileName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  void loadJsonFields() {
    final jsonData = widget.documentData['JSONDATA'];
    final data = jsonDecode(jsonData);
    switch (value) {
      case 0:
        startDateController.text = isoToLocalDate(data['STARTDATE']);
        endDateController.text = isoToLocalDate(data['ENDDATE']);
        daysController.text = data['DAYS'].toString();
        break;
      case 1:
        dateController.text = isoToLocalDate(data['DATE']);
        startTimeController.text = data['STARTTIME'].toString();
        endTimeController.text = data['ENDTIME'].toString();
        break;
      case 2:
        startDateController.text = isoToLocalDate(data['STARTDATE']);
        endDateController.text = isoToLocalDate(data['ENDDATE']);
        startTimeController.text = data['STARTTIME'].toString();
        endTimeController.text = data['ENDTIME'].toString();
        break;
      case 3:
        startDateController.text = isoToLocalDate(data['STARTDATE']);
        endDateController.text = isoToLocalDate(data['ENDDATE']);
        userController.text = getPersubaName;
        break;
      case 4:
        dateController.text = isoToLocalDate(data['DATE']);

        break;
      default:
        return;
    }
  }

  bool get isVacations {
    return value == 0;
  }

  bool get isPermission {
    return value == 1;
  }

  bool get isCommission {
    return value == 2;
  }

  bool get isChangeGuard {
    return value == 3;
  }

  bool get isAudience {
    return value == 4;
  }

  String get uploadedFileName {
    String? fileURL = widget.documentData['FILE'];
    if (fileURL == null) {
      return 'No hay archivo adjunto';
    }
    return fileURL.split('/').last;
  }

  void onTapDownloadFile() async {
    String? fileURL = widget.documentData['FILE'];
    if (fileURL == null) {
      return;
    }
    // Download file with dio
    final String? path = await FilePicker.platform.saveFile(
      fileName: uploadedFileName,
      lockParentWindow: true,
    );
    if (path == null) {
      return;
    }
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Descargando archivo...'),
      ),
    );
    await Dio().download(fileURL, path);
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Archivo descargado'),
      ),
    );
  }

  String get getPersubaName {
    final jsonData = widget.documentData['JSONDATA'];
    final data = jsonDecode(jsonData);
    final persubaDNI = data['PERSUBAUSER'] as int?;
    if (persubaDNI == null) {
      return '';
    }
    final persubaUser = widget.persubaUsers.firstWhere(
      (element) => element['DNI'] == persubaDNI,
      orElse: () => {'FULLNAME': '', 'DNI': ''},
    );
    return persubaUser['FULLNAME'];
  }

  String get getDocumentNumber {
    final documentId = widget.documentData['ID'];
    if (documentId == null) {
      return '-';
    }
    return documentId.toString();
  }
}
