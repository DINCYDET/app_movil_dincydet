import 'dart:io';

import 'package:app_movil_dincydet/api/api_managedocs.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/manage_docs/doc_asign_dialogs.dart';
import 'package:app_movil_dincydet/previews/previewPdfImage.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/formatters.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:camera/camera.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdfLibrary;

class DocumentReceivedNewDialog extends StatefulWidget {
  DocumentReceivedNewDialog({super.key});

  DocumentReceivedNewDialog.edit({
    super.key,
    required this.documentController,
    required this.date,
    required this.issueController,
    required this.destionationValue,
    required this.documentType,
    required this.pickedFile,
    required this.documentId,
  }) {
    editMode = true;
  }
  String? documentController;
  String? issueController;
  DateTime? date;
  int? destionationValue;
  int? documentType;
  File? pickedFile;

  bool editMode = false;
  int? documentId;
  @override
  State<DocumentReceivedNewDialog> createState() =>
      _DocumentReceivedNewDialogState();
}

class _DocumentReceivedNewDialogState extends State<DocumentReceivedNewDialog> {
  late final TextEditingController documentController =
      TextEditingController(text: widget.documentController ?? '');
  late final TextEditingController dateController = TextEditingController(
      text: date == null ? '' : '${date!.day}/${date!.month}/${date!.year}');
  late final TextEditingController issueController =
      TextEditingController(text: widget.issueController ?? '');
  late DateTime? date = widget.date;
  late int? destionationValue = widget.destionationValue;
  late int? documentType = widget.documentType;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        color: const Color(0xFF073264),
        alignment: Alignment.center,
        child: Text(
          '${widget.editMode ? 'Editar' : 'Registrar'} Documento Recibido',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: documentType,
                  decoration: const InputDecoration(
                    label: Text('Tipo de Documento'),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: List.generate(documentManagementTypes.length, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text(documentManagementTypes[index]),
                    );
                  }),
                  onChanged: onChangeDocumentType,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  label: 'Nº de Documento',
                  controller: documentController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    // lowercase to uppercase formatter
                    LowercaseToUppercaseInputFormatter(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  label: 'Fecha de Documento',
                  prefix: const Icon(Icons.calendar_today),
                  controller: dateController,
                  onTap: onTapDate,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  label: 'Asunto',
                  minLines: 4,
                  maxLines: 4,
                  controller: issueController,
                ),
                const SizedBox(
                  height: 30,
                ),
                SearchField<int>(
                  suggestions: List.generate(dependencies.length, (index) {
                    return SearchFieldListItem(
                      dependencies[index],
                      item: index,
                    );
                  }),
                  searchInputDecoration: const InputDecoration(
                    label: Text('Promotor'),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  controller: destionationValue != null
                      ? TextEditingController(
                          text: dependencies[destionationValue!])
                      : null,
                  suggestionAction: SuggestionAction.unfocus,
                  onSuggestionTap: onTapDestiny,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Adjuntos',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  child: pickedFile != null
                      ? Text(fileName.toString())
                      : const Icon(Icons.upload),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onTapTakeAPicture,
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
                            onPressed: onTapGallery,
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
                            onPressed: onTapDocument,
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
                            onPressed: onTapDocumentScanner,
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onTapSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101139),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: onTapCancel,
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
        )
      ],
    );
  }

  void onTapDestiny(SearchFieldListItem<int> p1) {
    destionationValue = p1.item;
    setState(() {});
  }

  void onChangeDocumentType(int? value) {
    documentType = value;
    setState(() {});
  }

  void onTapDate() {
    showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        date = value;
        dateController.text = '${value.day}/${value.month}/${value.year}';
      }
    });
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapSave() async {
    if (documentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un tipo de documento'),
        ),
      );
      return;
    }
    if (destionationValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un destino'),
        ),
      );
      return;
    }
    if (documentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un número de documento'),
        ),
      );
      return;
    }
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione una fecha'),
        ),
      );
      return;
    }
    if (issueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un asunto'),
        ),
      );
      return;
    }
    final dataMap = {
      'DOCUMENTTYPE': documentType,
      'DESTINATION': destionationValue,
      'DOCUMENT': documentController.text,
      'DATE': date?.toIso8601String(),
      'ISSUE': issueController.text,
    };
    if (pickedFile != null) {
      dataMap['files'] = await MultipartFile.fromFile(
        pickedFile!.path,
        filename: fileName,
      );
    }
    if (widget.editMode) {
      dataMap['ID'] = widget.documentId!;
      final response = await apiEditDocumentReceived(dataMap);
      if (response == null) return;
    } else {
      final response = await apiDocumentReceivedNew(dataMap);
      if (response == null) return;
    }
    Navigator.pop(context, true);
  }

  late File? pickedFile = widget.pickedFile;

  String? get fileName {
    return pickedFile?.path.replaceAll('\\', '/').split('/').last;
  }

  void onTapDocument() async {
    // load a pdf file
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (file == null) return;
    pickedFile = File(file.files.single.path!);
    setState(() {});
  }

  void onTapDocumentScanner() async {
    final now = DateTime.now();
    // load a pdf file
    List<String?>? imagesPath = [];
    try {
      imagesPath = await CunningDocumentScanner.getPictures();
      //TODO: multiples images in PDF
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
    if (imagesPath!.isEmpty) {
      return;
    }

    final pdf = pw.Document();
    for (var imagePath in imagesPath) {
      // final image = pdfLibrary.PdfImage.file(
      //   pdf.document,
      //   bytes: File(imagePath!).readAsBytesSync(),
      // );
      final image = File(imagePath!).readAsBytesSync();

      pdf.addPage(
        pw.Page(
          pageFormat: pdfLibrary.PdfPageFormat.undefined,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    final tempDir = await getTemporaryDirectory();
    final file = File(
        '${tempDir.path}/scanner_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.pdf');
    await file.writeAsBytes(await pdf.save());
    pickedFile = file;

    // pickedFile = File();
    setState(() {});
  }

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

  void onTapGallery() async {
    // load a image from gallery
    // final picker = ImagePicker();

    // final file = await picker.pickImage(source: ImageSource.gallery);
    // if (file == null) return;
    // pickedFile = File(file.path);

    // setState(() {});
    // final file = await FilePicker.platform.pickFiles(
    //   type: FileType.image,
    // );
    final file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (file == null) return;
    pickedFile = File(file.files.single.path!);
    setState(() {});
  }
}

class DocumentReceivedViewDialog extends StatelessWidget {
  const DocumentReceivedViewDialog({
    super.key,
    required this.data,
    required this.oficials,
  });
  final Map<String, dynamic> data;
  final List<dynamic> oficials;

  @override
  Widget build(BuildContext context) {
    // Verify if FILE is not null or is not empty

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
                    fontSize: 17.0,
                  ),
                ),
              ),
              IconButton(
                onPressed: onTapAsign,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
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
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            child: PreviewPdfImg(data['FILE'])),
      ],
    );
  }

  void onTapAsign() async {
    Map<String, dynamic>? data = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return DocumentAsignDialog(
            oficials: oficials, //TODO: Traer los oficiales
          );
        });
    if (data == null) return;
    data['ID'] = this.data['ID'];
    final response = await apiDocumentAssign(data);
    if (response == null) return;
    Navigator.pop(navigatorKey.currentContext!, true);
  }

  bool get hasFile => data['FILE'] != null && data['FILE'].isNotEmpty;

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
    final url = data['FILE'];
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
}

//Pagina para tomar foto
class TakePictureCamera extends StatefulWidget {
  const TakePictureCamera({super.key});

  @override
  State<TakePictureCamera> createState() => _TakePictureCameraState();
}

class _TakePictureCameraState extends State<TakePictureCamera> {
  XFile? imageFile;
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Captura de foto',
      section: DrawerSection.other,
      drawer: false,
      body: controller.value.isInitialized
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CameraPreview(controller),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: onTapTakePicture,
                      backgroundColor: Colors.black,
                      tooltip: 'Tomar Foto',
                      child: const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                )
              ],
            )
          : const Center(
              child: Text('Camara no inicializada'),
            ),
    );
  }

  void onTapTakePicture() async {
    await takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
    Navigator.of(context).pop(imageFile);
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }
}
