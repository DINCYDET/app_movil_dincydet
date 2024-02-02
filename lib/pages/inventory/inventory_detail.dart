// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_movil_dincydet/api/api_inventory.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/qrcodes.dart';
import 'package:app_movil_dincydet/utils/mywidgets/renderqr.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class InventoryDetailDialog extends StatefulWidget {
  const InventoryDetailDialog({
    super.key,
    required this.projectsList,
    required this.data,
    this.editable = false,
  });
  final List<Map<String, dynamic>> projectsList;
  final bool editable;
  final Map<String, dynamic> data;
  @override
  State<InventoryDetailDialog> createState() => _InventoryDetailDialogState();
}

class _InventoryDetailDialogState extends State<InventoryDetailDialog> {
  final TextEditingController characteristicsController =
      TextEditingController();
  final TextEditingController itemTypeController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController orderController = TextEditingController();
  final TextEditingController ibpController = TextEditingController();
  final TextEditingController factureController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController NEAController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  int? locationValue;
  int? conditionValue;
  int? originValue;
  int? itemTypeValue;

  File? pickedIMG;
  File? pickedFile;
  File? pickedOrder;
  File? pickedFacture;
  File? pickedNEA;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data.isNotEmpty) {
      ibpController.text = widget.data['IBP'] ?? '';
      brandController.text = widget.data['BRAND'] ?? '';
      modelController.text = widget.data['MODEL'] ?? '';
      serialController.text = widget.data['SERIAL'] ?? '';
      characteristicsController.text = widget.data['CHARACTERISTICS'] ?? '';

      //originController.text = widget.data['ORIGIN'];
      orderController.text = widget.data['ORDER'];
      factureController.text = widget.data['FACTURE'];
      NEAController.text = widget.data['NEA'];
      locationValue = widget.data['LOCATION'];
      conditionValue = widget.data['CONDITION'];
      originValue = widget.data['PROJECTID'];
      itemTypeValue = widget.data['TYPE'];
      itemTypeController.text = inventoryTypes[widget.data['TYPE']];
      originValue = widget.data['PROJECTID'];
      final isProject = widget.data['ISPROJECT'] == true;
      originController.text =
          isProject ? widget.data['PROJECTNAME'] : 'DINCYDET';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF073264),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Ficha de Registro de Bien',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const Spacer(),
            Visibility(
              visible: widget.editable,
              child: InkWell(
                onTap: onTapSave,
                child: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
            ),
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
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: InkWell(
                              onTap: widget.editable ? onTapPickIMG : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: !isPickedIMG
                                    ? CachedNetworkImageBuilder(
                                        url: widget.data['IMAGE'] ?? '-',
                                        errorWidget: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                        builder: (image) {
                                          return Image.file(
                                            pickedIMG ?? image,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.file(
                                        pickedIMG!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(0.0),
                              child: QrImage(
                                data: qrStringInventory(widget.data['ID']),
                                title: inventoryTypes[widget.data['TYPE']],
                                subtitle: widget.data['IBP'],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SearchField<int>(
                      searchInputDecoration: const InputDecoration(
                        labelText: 'Origen de Adquisición',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      controller: originController,
                      readOnly: !widget.editable,
                      suggestions: widget.editable
                          ? List.generate(widget.projectsList.length, (index) {
                              return SearchFieldListItem(
                                widget.projectsList[index]['NAME'],
                                item: widget.projectsList[index]['ID'],
                              );
                            })
                          : [],
                      onSuggestionTap: onTapProject,
                      suggestionAction: SuggestionAction.unfocus,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Condición final',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: List.generate(inventoryConditions.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(inventoryConditions[index]),
                        );
                      }),
                      onChanged: widget.editable ? onChangedCondition : null,
                      isExpanded: true,
                      value: conditionValue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text(
                          'Nº de Orden de Compra',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      controller: orderController,
                      readOnly: !widget.editable,
                      onTap: onTapDownloadOrder,
                    ),
                    Visibility(
                      visible: widget.editable,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: InkWell(
                          onTap: onTapPickOrder,
                          child: Icon(
                            Icons.file_upload,
                            color: isPickedOrder ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: List.generate(areasDincydet.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(areasDincydet[index]),
                        );
                      }),
                      onChanged: widget.editable ? onChangedLocation : null,
                      isExpanded: true,
                      value: locationValue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      label: 'Marca',
                      controller: brandController,
                      readOnly: !widget.editable,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text(
                          'Factura',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      controller: factureController,
                      readOnly: !widget.editable,
                      onTap: onTapDownloadFacture,
                    ),
                    Visibility(
                      visible: widget.editable,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: InkWell(
                          onTap: onTapPickFacture,
                          child: Icon(
                            Icons.file_upload,
                            color: isPickedFacture ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SearchField<int>(
                      searchInputDecoration: const InputDecoration(
                        labelText: 'Tipo de bien',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      controller: itemTypeController,
                      readOnly: !widget.editable,
                      suggestions: widget.editable
                          ? List.generate(
                              inventoryTypes.length,
                              (index) {
                                return SearchFieldListItem(
                                  inventoryTypes[index],
                                  item: index,
                                );
                              },
                            )
                          : [],
                      suggestionAction: SuggestionAction.unfocus,
                      onSuggestionTap: onTapItemType,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      label: 'Modelo',
                      controller: modelController,
                      readOnly: !widget.editable,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text(
                          'NEA',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      controller: NEAController,
                      readOnly: !widget.editable,
                      onTap: onTapDownloadNEA,
                    ),
                    Visibility(
                      visible: widget.editable,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: InkWell(
                          onTap: onTapPickNEA,
                          child: Icon(
                            Icons.file_upload,
                            color: isPickedNEA ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      label: 'IBP',
                      controller: ibpController,
                      readOnly: !widget.editable,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      label: 'Serie',
                      controller: serialController,
                      readOnly: !widget.editable,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: widget.editable,
                      child: const Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.file_upload,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: MyTextField(
                            label: 'Características',
                            controller: characteristicsController,
                            minLines: 3,
                            maxLines: 3,
                            readOnly: !widget.editable,
                          ),
                        ),
                        Visibility(
                          visible: widget.editable,
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.file_upload,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void onTapPickIMG() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (results == null) return;
    pickedIMG = File(results.files.single.path!);
    setState(() {});
  }

  void onTapPickFile() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (results == null) return;
    pickedFile = File(results.files.single.path!);
    setState(() {});
  }

  void onTapPickOrder() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (results == null) return;
    pickedOrder = File(results.files.single.path!);
    setState(() {});
  }

  void onTapPickFacture() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (results == null) return;
    pickedFacture = File(results.files.single.path!);
    setState(() {});
  }

  void onTapPickNEA() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (results == null) return;
    pickedNEA = File(results.files.single.path!);
    setState(() {});
  }

  String get imageName {
    if (pickedIMG == null) return 'Seleccionar Imagen';
    return pickedIMG!.path.replaceAll('\\', '/').split('/').last;
  }

  String get fileName {
    if (pickedFile == null) return 'Seleccionar Archivo';
    return pickedFile!.path.replaceAll('\\', '/').split('/').last;
  }

  bool get isPickedOrder =>
      pickedOrder != null || widget.data['ORDERFILE'] != null;
  bool get isPickedFacture =>
      pickedFacture != null || widget.data['FACTUREFILE'] != null;
  bool get isPickedNEA => pickedNEA != null || widget.data['NEAFILE'] != null;
  bool get isPickedIMG => pickedIMG != null;
  bool get isPickedFile => pickedFile != null;

  void onChangedLocation(int? value) {
    if (locationValue == value) return;
    locationValue = value;
    setState(() {});
  }

  void onChangedCondition(int? value) {
    if (conditionValue == value) return;
    conditionValue = value;
    setState(() {});
  }

  void onTapProject(SearchFieldListItem<int> p1) {
    if (originValue == p1.item) return;
    originValue = p1.item;
    setState(() {});
  }

  void onTapItemType(SearchFieldListItem<int> p1) {
    if (itemTypeValue == p1.item) return;
    itemTypeValue = p1.item;
    setState(() {});
  }

  void onTapSave() async {
    final dataMap = {
      'ID': widget.data['ID'],
      'IBP': ibpController.text,
      'BRAND': brandController.text,
      'MODEL': modelController.text,
      'SERIAL': serialController.text,
      'CHARACTERISTICS': characteristicsController.text,
      'ORDER': orderController.text,
      'FACTURE': factureController.text,
      'NEA': NEAController.text,
      'LOCATION': locationValue,
      'CONDITION': conditionValue,
      'TYPE': itemTypeValue,
      'ISPROJECT': originValue != -1,
      'PROJECTID': originValue != -1 ? originValue : null,
    };

    if (pickedOrder != null) {
      dataMap['order'] = await MultipartFile.fromFile(pickedOrder!.path);
    }
    if (pickedFacture != null) {
      dataMap['facture'] = await MultipartFile.fromFile(pickedFacture!.path);
    }
    if (pickedNEA != null) {
      dataMap['nea'] = await MultipartFile.fromFile(pickedNEA!.path);
    }
    if (pickedIMG != null) {
      dataMap['images'] = await MultipartFile.fromFile(pickedIMG!.path);
    }
    final results = await apiInventoryUpdate(dataMap);
    if (results == null) return;
    navigatorKey.currentState!.pop(true);
  }

  void onTapDownloadOrder() async {
    if (widget.editable) return;
    final url = widget.data['ORDERFILE'];
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay archivo')),
      );
      return;
    }
    final name = url.split('/').last;
    final path = await FilePicker.platform.saveFile(
      fileName: name,
      type: FileType.any,
    );
    if (path == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando...')),
    );
    await Dio().download(url, path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descarga completada')),
    );
  }

  void onTapDownloadFacture() async {
    if (widget.editable) return;
    final url = widget.data['FACTUREFILE'];
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay archivo')),
      );
      return;
    }
    final name = url.split('/').last;
    final path = await FilePicker.platform.saveFile(
      fileName: name,
      type: FileType.any,
    );
    if (path == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando...')),
    );
    Dio().download(url, path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descarga completada')),
    );
  }

  void onTapDownloadNEA() async {
    if (widget.editable) return;
    final url = widget.data['NEAFILE'];
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay archivo')),
      );
      return;
    }
    final name = url.split('/').last;
    final path = await FilePicker.platform.saveFile(
      fileName: name,
      type: FileType.any,
    );
    if (path == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descargando...')),
    );
    Dio().download(url, path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descarga completada')),
    );
  }
}
