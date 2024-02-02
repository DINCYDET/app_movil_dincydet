import 'dart:convert';
import 'dart:io';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DocumentNewDialog extends StatefulWidget {
  const DocumentNewDialog({
    super.key,
    required this.persubaUsers,
  });
  final List<Map<String, dynamic>> persubaUsers;
  @override
  State<DocumentNewDialog> createState() => _DocumentNewDialogState();
}

class _DocumentNewDialogState extends State<DocumentNewDialog> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController toUserController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  int value = 0;
  int? persubaUserValue;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? date;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(20.0),
      title: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF073264),
        ),
        child: Row(
          children: [
            const Spacer(),
            const Text(
              'Papeleta de Autorización Nº XX',
              style: TextStyle(
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
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
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
                onChanged: onChangePicker,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: descriptionController,
                label: 'Descripción',
                minLines: 4,
                maxLines: 4,
              ),
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  label: Text('Adjuntar Archivo'),
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: onTapPickFile,
                  child: pickedFile != null
                      ? Text(
                          pickedFileName,
                          textAlign: TextAlign.center,
                        )
                      : const Icon(Icons.upload_file),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Dropdown to select the type of document
              Visibility(
                visible: isVacations || isCommission || isChangeGuard,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:
                        isChangeGuard ? 'Fecha de Guardia' : 'Fecha de Inicio',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: startDateController,
                  onTap: onTapStartDate,
                ),
              ),
              Visibility(
                visible: isVacations || isCommission || isChangeGuard,
                child: const SizedBox(
                  height: 20,
                ),
              ),
              Visibility(
                visible: isVacations || isCommission || isChangeGuard,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:
                        isChangeGuard ? 'Fecha de Devolución' : 'Fecha de Fin',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: endDateController,
                  onTap: onTapEndDate,
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
                  onTap: onTapDate,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
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
                              onTap: onTapStartTime,
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
                              onTap: onTapEndTime,
                              prefix: const Icon(Icons.access_time),
                              controller: endTimeController,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isChangeGuard,
                          child: Expanded(
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Aceptante',
                                border: OutlineInputBorder(),
                              ),
                              value: persubaUserValue,
                              items: List.generate(
                                widget.persubaUsers.length,
                                (index) {
                                  final item = widget.persubaUsers[index];
                                  return DropdownMenuItem(
                                    value: index,
                                    child: Text(item['FULLNAME']),
                                  );
                                },
                              ),
                              onChanged: onChangedPersubaUser,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF101139),
                    ),
                    onPressed: onTapGenerate,
                    child: const Text('Generar Papeleta'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF101139),
                    ),
                    onPressed: onTapCancel,
                    child: const Text('Cancelar'),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapGenerate() async {
    Map<String, dynamic> baseData = {
      'DESCRIPTION': descriptionController.text,
      'TYPE': value,
    };
    if (pickedFile != null) {
      baseData['files'] = await MultipartFile.fromFile(pickedFile!.path);
    }
    Map<String, dynamic> data = {};
    switch (value) {
      case 0:
        // Vacaciones
        if (startDate == null || endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione las fechas de inicio y fin'),
            ),
          );
          return;
        }

        data['STARTDATE'] = startDate!.toIso8601String();
        data['ENDDATE'] = endDate!.toIso8601String();
        data['DAYS'] = int.tryParse(daysController.text) ?? 0;

        if (data['DAYS'] > 22) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El máximo de días es 22'),
            ),
          );
          return;
        }

        break;
      case 1:
        // Permiso
        if (date == null || startTime == null || endTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione la fecha y hora de inicio y fin'),
            ),
          );
          return;
        }
        data['DATE'] = date!.toIso8601String();
        data['STARTTIME'] = startTime!.format(context);
        data['ENDTIME'] = endTime!.format(context);
        break;
      case 2:
        // Comisión
        if (startDate == null ||
            endDate == null ||
            startTime == null ||
            endTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione la fecha y hora de inicio y fin'),
            ),
          );
          return;
        }
        data['STARTDATE'] = startDate!.toIso8601String();
        data['ENDDATE'] = endDate!.toIso8601String();
        data['STARTTIME'] = startTime!.format(context);
        data['ENDTIME'] = endTime!.format(context);

        break;
      case 3:
        // Cambio de Guardia
        if (startDate == null || endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione la fecha de inicio y fin'),
            ),
          );
          return;
        }
        if (persubaUserValue == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione el aceptante'),
            ),
          );
          return;
        }
        data['STARTDATE'] = startDate!.toIso8601String();
        data['ENDDATE'] = endDate!.toIso8601String();
        data['PERSUBAUSER'] = widget.persubaUsers[persubaUserValue!]['DNI'];
        break;
      case 4:
        // Audiencia
        if (date == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleccione la fecha'),
            ),
          );
          return;
        }
        data['DATE'] = date!.toIso8601String();
        break;
      default:
        return;
    }
    baseData['JSONDATA'] = jsonEncode(data);
    Navigator.pop(context, baseData);
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

  void onChangePicker(int? newValue) {
    print(newValue);
    setState(() {
      value = newValue!;
    });
  }

  void onTapStartDate() async {
    // Pick a date and set the value to startDate, startDate should be before endDate
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: endDate ?? DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
        startDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      calculateDays();
    }
  }

  void onTapEndDate() async {
    // Pick a date and set the value to endDate, endDate should be after startDate
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
        endDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      calculateDays();
    }
  }

  void calculateDays() {
    // Calculate the days between startDate and endDate, dont count weekends
    if (startDate != null && endDate != null) {
      int days = 0;
      DateTime date = startDate!;
      while (date.isBefore(endDate!)) {
        if (date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday) {
          days++;
        }
        date = date.add(const Duration(days: 1));
      }
      daysController.text = days.toString();
    }
  }

  void onTapDate() async {
    // Pick a date and set the value to date
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        date = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void onTapStartTime() async {
    // Pick a time and set the value to startTime
    TimeOfDay? pickedTime = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        startTime = pickedTime;
        startTimeController.text = pickedTime.format(context);
      });
    }
  }

  void onTapEndTime() async {
    // Pick a time and set the value to endTime
    TimeOfDay? pickedTime = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        endTime = pickedTime;
        endTimeController.text = pickedTime.format(context);
      });
    }
  }

  void onChangedPersubaUser(int? value) {
    setState(() {
      persubaUserValue = value!;
    });
  }

  void onTapPickFile() async {
    // Pick a file and set the value to file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        pickedFile = File(result.files.single.path!);
      });
    }
  }

  String get pickedFileName {
    if (pickedFile != null) {
      return pickedFile!.path.replaceAll('\\', '/').split('/').last;
    }
    return 'Seleccione un archivo';
  }
}
