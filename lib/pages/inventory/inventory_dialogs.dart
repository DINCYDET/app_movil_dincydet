import 'dart:io';

import 'package:app_movil_dincydet/api/api_inventory.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class InventoryNewDialog extends StatefulWidget {
  const InventoryNewDialog({
    super.key,
    required this.projectsList,
  });

  final List<Map<String, dynamic>> projectsList;
  @override
  State<InventoryNewDialog> createState() => _InventoryNewDialogState();
}

class _InventoryNewDialogState extends State<InventoryNewDialog> {
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
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(20.0),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: const Color(0xFF073264),
        alignment: Alignment.center,
        child: const Text(
          'Registrar Nuevo Bien',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SearchField<int>(
                searchInputDecoration: const InputDecoration(
                  labelText: 'Origen de Adquisición',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                controller: originController,
                suggestions: List.generate(widget.projectsList.length, (index) {
                  return SearchFieldListItem(
                    widget.projectsList[index]['NAME'],
                    item: widget.projectsList[index]['ID'],
                  );
                }),
                onSuggestionTap: onTapProject,
                suggestionAction: SuggestionAction.unfocus,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Características',
                controller: characteristicsController,
                minLines: 1,
                maxLines: 1,
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
                suggestions: List.generate(
                  inventoryTypes.length,
                  (index) {
                    return SearchFieldListItem(
                      inventoryTypes[index],
                      item: index,
                    );
                  },
                ),
                suggestionAction: SuggestionAction.unfocus,
                onSuggestionTap: onTapItemType,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      label: 'Nº de Orden de Compra',
                      controller: orderController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: onTapPickOrder,
                    color: isPickedOrder ? Colors.green : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'IBP',
                controller: ibpController,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      label: 'Factura',
                      controller: factureController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: onTapPickFacture,
                    color: isPickedFacture ? Colors.green : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Marca',
                controller: brandController,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      label: 'NEA',
                      controller: NEAController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: onTapPickNEA,
                    color: isPickedNEA ? Colors.green : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Modelo',
                controller: modelController,
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
                onChanged: onChangedCondition,
                isExpanded: true,
                value: conditionValue,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                label: 'Serie',
                controller: serialController,
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
                onChanged: onChangedLocation,
                isExpanded: true,
                value: locationValue,
              ),
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  label: Text('Adjuntar Imagen'),
                  border: OutlineInputBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.file_upload_outlined),
                  onPressed: onTapPickIMG,
                  color: isPickedIMG ? Colors.green : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  label: Text('Adjuntar Archivo'),
                  border: OutlineInputBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.file_upload_outlined),
                  onPressed: onTapPickFile,
                  color: isPickedFile ? Colors.green : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onTapRegisterItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF073264),
                    ),
                    child: const Text('Registrar'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF073264),
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

  bool get isPickedOrder => pickedOrder != null;
  bool get isPickedFacture => pickedFacture != null;
  bool get isPickedNEA => pickedNEA != null;
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

  void onTapRegisterItem() async {
    //TODO: Add validation to all fields
    if (ibpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('IBP es requerido'),
        ),
      );
      return;
    }
    if (serialController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serie es requerido'),
        ),
      );
      return;
    }
    if (locationValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ubicación es requerido'),
        ),
      );
      return;
    }
    if (itemTypeValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tipo de Item es requerido'),
        ),
      );
      return;
    }
    if (originValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Origen es requerido'),
        ),
      );
      return;
    }
    if (conditionValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Condición es requerido'),
        ),
      );
      return;
    }
    final dataMap = {
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
    // TODO: upload files
    if (pickedIMG != null) {
      dataMap['images'] = await MultipartFile.fromFile(pickedIMG!.path);
    }
    if (pickedFile != null) {
      dataMap['files'] = await MultipartFile.fromFile(pickedFile!.path);
    }
    if (pickedOrder != null) {
      dataMap['order'] = await MultipartFile.fromFile(pickedOrder!.path);
    }
    if (pickedFacture != null) {
      dataMap['facture'] = await MultipartFile.fromFile(pickedFacture!.path);
    }
    if (pickedNEA != null) {
      dataMap['nea'] = await MultipartFile.fromFile(pickedNEA!.path);
    }

    final results = await apiInventoryAdd(dataMap);
    if (results == null) return;
    navigatorKey.currentState!.pop(true);
  }
}
