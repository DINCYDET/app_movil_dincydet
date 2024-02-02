import 'dart:io';

import 'package:app_movil_dincydet/api/api_managedocs.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_received_dialogs.dart';
import 'package:app_movil_dincydet/previews/previewPdfImage.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DocumentAsignDialog extends StatefulWidget {
  const DocumentAsignDialog({
    super.key,
    required this.oficials,
  });
  final List<dynamic> oficials;
  @override
  State<DocumentAsignDialog> createState() => _DocumentAsignDialogState();
}

class _DocumentAsignDialogState extends State<DocumentAsignDialog> {
  int? oficialUser;
  int? actionValue;
  DateTime? actionDate;
  TextEditingController actionDateController = TextEditingController();
  TimeOfDay? actionTime;
  TextEditingController actionTimeController = TextEditingController();
  TextEditingController decreteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        color: const Color(0xFF101139),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        alignment: Alignment.center,
        child: const Text(
          'Asignar documento',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  label: Text('Ejecución'),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                isExpanded: true,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                ),
                isDense: true,
                value: oficialUser,
                onChanged: (int? value) {
                  setState(() {
                    oficialUser = value;
                  });
                },
                items: List.generate(widget.oficials.length, (index) {
                  final item = widget.oficials[index];
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(item['FULLNAME']),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: actionDateController,
                label: 'Fecha de acción',
                readOnly: true,
                prefix: const Icon(Icons.calendar_today_outlined),
                onTap: onTapActionDate,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  label: Text('Acciones'),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                value: actionValue,
                isExpanded: true,
                onChanged: (int? value) {
                  setState(() {
                    actionValue = value;
                  });
                },
                items: List.generate(actionTypes.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(actionTypes[index]),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: actionTimeController,
                label: 'Hora',
                readOnly: true,
                prefix: const Icon(Icons.access_time_outlined),
                onTap: onTapActionTime,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                label: 'Decreto',
                minLines: 3,
                maxLines: 3,
                controller: decreteController,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final dataMap = {
                        'ASIGNEDUSER': widget.oficials[oficialUser!]['DNI'],
                        'ACTIONSETTED': actionValue,
                        'ACTIONDATE': actionDate?.toIso8601String(),
                        'ACTIONHOUR': actionTime?.format(context),
                        'DECRET': decreteController.text,
                      };
                      Navigator.of(context).pop(dataMap);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF101139),
                    ),
                    child: const Text('Enviar'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF101139),
                    ),
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

  void onTapActionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) {
      return;
    }
    actionDate = pickedDate;
    actionDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }

  void onTapActionTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) {
      return;
    }
    actionTime = pickedTime;
    actionTimeController.text = pickedTime.format(context);
  }
}

class DocumentAssignedViewDialog extends StatefulWidget {
  const DocumentAssignedViewDialog({
    super.key,
    required this.data,
  });
  final Map<String, dynamic> data;

  @override
  State<DocumentAssignedViewDialog> createState() =>
      _DocumentAssignedViewDialogState();
}

class _DocumentAssignedViewDialogState
    extends State<DocumentAssignedViewDialog> {
  final TextEditingController actionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initWidget();
  }

  void initWidget() {
    actionController.text = widget.data['ACTIONLABEL'] ?? '';
    fileName = widget.data['ACTIONFILE']?.split('/').last;
  }

  late bool completed = widget.data['STAGE'] == 2;

  bool get hasFile =>
      widget.data['FILE'] != null && widget.data['FILE'].isNotEmpty;

  bool get hasActionFile =>
      widget.data['ACTIONFILE'] != null && widget.data['ACTIONFILE'].isNotEmpty;

  @override
  void initState() {
    initWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        alignment: Alignment.center,
        color: const Color(0xFF101139),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Vista Documento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              IconButton(
                onPressed: onTapDownload,
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
              ),
              Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF101139),
                      width: 2.0,
                    ),
                    top: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF101139),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(10.0),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF101139),
                      width: 1.0,
                    ),
                  ),
                  child: PreviewPdfImg(widget.data['FILE']),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: actionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Acción Tomada',
                ),
                readOnly: completed,
                maxLines: 3,
                minLines: 3,
              ),
              const SizedBox(
                height: 15,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Adjuntar Archivo',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: fileName == null
                      ? const Icon(
                          Icons.cloud_upload,
                          size: 30,
                        )
                      : GestureDetector(
                          onTap: onTapActionFile,
                          child: Text(
                            fileName!,
                            style: hasActionFile
                                ? const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  )
                                : null,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: completed ? null : onTapTakeAPicture,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            foregroundColor: const Color(0xFF6750A4),
                          ),
                          icon: const Icon(Icons.camera),
                          label: const Text('Camara'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: completed ? null : onTapGallery,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            foregroundColor: const Color(0xFF6750A4),
                          ),
                          icon: const Icon(Icons.photo_album),
                          label: const Text('Galeria'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: completed ? null : onTapDocument,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            foregroundColor: const Color(0xFF6750A4),
                          ),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Documento'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: completed ? null : onTapDocumentScanner,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            foregroundColor: const Color(0xFF6750A4),
                          ),
                          icon: const Icon(Icons.document_scanner_outlined),
                          label: const Text('Scanner'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: completed ? null : onTapAccept,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF101139),
                    ),
                    child: const Text('Aceptar'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF101139),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void onTapAccept() async {
    final dataMap = {
      'ID': widget.data['ID'],
      'ACTIONLABEL': actionController.text,
    };
    if (pickedFile != null) {
      dataMap['files'] = [
        await MultipartFile.fromFile(pickedFile!.path),
      ];
    }
    final response = await apiDocumentComplete(dataMap);
    if (response == null) return;
    Navigator.pop(navigatorKey.currentContext!, true);
  }

  File? pickedFile;
  String? fileName;

  void onTapTakeAPicture() async {
    final file = await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => const TakePictureCamera(),
      ),
    );

    if (file == null) return;
    pickedFile = File(file.path);

    setState(() {});
  }

  void onTapDocumentScanner() async {
    // load a pdf file
    List<String?>? imagesPath = [];
    try {
      imagesPath = await CunningDocumentScanner.getPictures();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrio un error, inténtelo de nuevo.'),
        ),
      );
    }
    if (kDebugMode) {
      print('****************************************** $imagesPath');
    }
    if (imagesPath!.isEmpty || imagesPath.length >= 2) {
      return;
    }
    pickedFile = File(imagesPath[0]!);
    setState(() {});
  }

  void onTapDocument() async {
    // Upload a pdf file, max 1MB
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result == null) return;
    pickedFile = File(result.files.single.path!);
    fileName = result.files.single.name;
    setState(() {});
  }

  void onTapGallery() async {
    // load a image from gallery
    final file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (file == null) return;
    pickedFile = File(file.files.single.path!);
    setState(() {});
  }

  void onTapDownload() async {
    if (!hasFile) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('No se adjuntó un archivo'),
        ),
      );
      return;
    }
    // Download the pdf file from the server
    final url = widget.data['FILE'];
    final fileName = url.split('/').last;
    String? filePath;
    if (Platform.isAndroid || Platform.isIOS) {
      Directory? directory = await getApplicationDocumentsDirectory();
      filePath = directory.path;
    }
    if (Platform.isWindows || Platform.isMacOS) {
      Directory? directory = await getDownloadsDirectory();
      filePath = directory?.path;
    }
    if (filePath == null) return;
    // Download the file with dio
    final dio = Dio();
    final response = await dio.download(url, '$filePath/$fileName');
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Descarga exitosa'),
        ),
      );
    }
  }

  void onTapActionFile() async {
    if (!hasActionFile) {
      return;
    }
    // Download the pdf file from the server
    final url = widget.data['ACTIONFILE'];
    final fileName = url.split('/').last;
    String? filePath;
    if (Platform.isAndroid || Platform.isIOS) {
      Directory? directory = await getApplicationDocumentsDirectory();
      filePath = directory.path;
    }
    if (Platform.isWindows || Platform.isMacOS) {
      Directory? directory = await getDownloadsDirectory();
      filePath = directory?.path;
    }
    if (filePath == null) return;
    // Download the file with dio
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Iniciando descarga'),
      ),
    );
    final dio = Dio();
    final response = await dio.download(url, '$filePath/$fileName');
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Descarga exitosa'),
        ),
      );
    }
  }
}
