import 'dart:convert';
import 'dart:io';

import 'package:app_movil_dincydet/api/api_budget.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/src/searchfield.dart';

class BudgetNewProvider extends ChangeNotifier {
  BudgetNewProvider() {
    loadCodesJSON();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProjectsList();
    });
  }

  final TextEditingController namePS1Controller = TextEditingController();
  final TextEditingController namePS2Controller = TextEditingController();
  final TextEditingController namePE1Controller = TextEditingController();
  final TextEditingController namePE2Controller = TextEditingController();
  final TextEditingController namePSubEController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController fromController = TextEditingController();

  void onTapAdd() {
    // TODO: Add alerts to show errors
    if (fullCode == null) {
      return;
    }
    if (descriptionController.text.isEmpty) {
      return;
    }
    if (projectKey == null) {
      return;
    }
    String amountText = amountController.text;
    if (amountText.isEmpty) {
      amountText = '0';
    }
    budgetData.insert(
      0,
      {
        'DEPARTURE': fullCode,
        'DESCRIPTION': descriptionController.text,
        'DETAIL': detailController.text,
        'AMOUNT': double.parse(amountText),
        'PROJECTID': projectKey,
        'ISPROJECT': projectKey != -1,
        'FROM': fromController.text,
        'FILE': pickedFile,
      },
    );
    // Clean fields
    onTapClean();
  }

  void onTapClean() {
    namePS1Controller.clear();
    namePS2Controller.clear();
    namePE1Controller.clear();
    namePE2Controller.clear();
    namePSubEController.clear();
    descriptionController.clear();
    detailController.clear();
    fileController.clear();
    amountController.clear();
    fromController.clear();
    ps1Key = null;
    ps2Key = null;
    pe1Key = null;
    pe2Key = null;
    pSubEKey = null;
    projectKey = null;
    pickedFile = null;
    notifyListeners();
  }

  void onTapRemoveItem(int index) {
    budgetData.removeAt(index);
    notifyListeners();
  }

  List<Map> budgetData = [];

  void onTapRequest() async {
    // Show dialog to confirm the action
    bool? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '¿Está seguro de solicitar\npresupuesto?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF073264),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF073264),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Si')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: const Color(0xFF073264),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No')),
                ],
              )
            ],
          );
        });
    if (complete != true) return;
    // Send request
    final num totalAmount = budgetData.fold(
        0, (previousValue, element) => previousValue + element['AMOUNT']);

    final key = budgetData[0]['PROJECTID'];
    final dataMap = {
      'AMOUNT': totalAmount.toDouble(),
      'ISPROJECT': key != -1,
      'PROJECTID': key != -1 ? key : null,
    };
    for (int i = 0; i < budgetData.length; i++) {
      final file = budgetData[i].remove('FILE') as File?;
      if (file != null) {
        dataMap['FILE$i'] = await MultipartFile.fromFile(file.path);
      }
    }
    dataMap['ITEMS'] = jsonEncode(budgetData);
    Map<String, dynamic>? response = await apiBudgetNew(dataMap);
    if (response == null) {
      return;
    }
    navigatorKey.currentState!.pop(true);
  }

  void onTapCancel() async {
    // Show dialog to confirm the action
    bool? complete = await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return SimpleDialog(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '¿Está seguro de Cancelar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB3261E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFB3261E),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Si')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: const Color(0xFF073264),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No')),
                ],
              )
            ],
          );
        });
    if (complete != true) return;
    navigatorKey.currentState!.pop();
  }

  Map? codesMap;
  String ps0Key = "2";
  String? ps1Key;
  String? ps2Key;
  String? pe1Key;
  String? pe2Key;
  String? pSubEKey;

  Map get ps1Suggestions {
    if (codesMap == null) return {};
    return codesMap!['2']['children'];
  }

  Map get ps2Suggestions {
    if (codesMap == null) return {};
    if (ps1Key == null) return {};
    return codesMap!['2']['children'][ps1Key]['children'];
  }

  Map get pe1Suggestions {
    if (codesMap == null) return {};
    if (ps2Key == null) return {};
    return codesMap!['2']['children'][ps1Key]['children'][ps2Key]['children'];
  }

  Map get pe2Suggestions {
    if (codesMap == null) return {};
    if (pe1Key == null) return {};
    return codesMap!['2']['children'][ps1Key]['children'][ps2Key]['children']
        [pe1Key]['children'];
  }

  Map get pSubESuggestions {
    if (codesMap == null) return {};
    if (pe2Key == null && pe1Key == null && ps2Key == null && ps1Key == null) {
      // Return all childrens
      Map childrens = {};
      Map codes = codesMap!['2']['children'];
      for (var element in codes.keys) {
        Map codes2 = codes[element]['children'];
        for (var element2 in codes2.keys) {
          Map codes3 = codes2[element2]['children'];
          for (var element3 in codes3.keys) {
            Map codes4 = codes3[element3]['children'];
            for (var element4 in codes4.keys) {
              Map codes5 = codes4[element4]['children'];
              for (var element5 in codes5.keys) {
                String name =
                    "2.$element.$element2.$element3.$element4.$element5";
                childrens[name] = codes5[element5];
              }
            }
          }
        }
      }
      return childrens;
    } //TODO: continue
    if (pe2Key == null) return {};
    return codesMap!['2']['children'][ps1Key]['children'][ps2Key]['children']
        [pe1Key]['children'][pe2Key]['children'];
  }

  String? get fullCode {
    if (ps1Key == null) return null;
    if (ps2Key == null) return null;
    if (pe1Key == null) return null;
    if (pe2Key == null) return null;
    if (pSubEKey == null) return null;
    return '$ps0Key.$ps1Key.$ps2Key.$pe1Key.$pe2Key.$pSubEKey';
  }

  // Code for load the codes
  void loadCodesJSON() async {
    // Load the json file from assets folder
    String data = await DefaultAssetBundle.of(navigatorKey.currentContext!)
        .loadString('assets/json/Clasificador.json');
    // Decode the json file
    codesMap = jsonDecode(data);

    // Notify the listeners
    notifyListeners();
  }

  void onTapPS1Key(SearchFieldListItem<String> p1) {
    if (p1.item == ps1Key) return;
    ps1Key = p1.item;
    ps2Key = null;
    pe1Key = null;
    pe2Key = null;
    pSubEKey = null;
    namePS2Controller.clear();
    namePE1Controller.clear();
    namePE2Controller.clear();
    namePSubEController.clear();
    notifyListeners();
  }

  void onTapPS2Key(SearchFieldListItem<String> p1) {
    if (p1.item == ps2Key) return;
    ps2Key = p1.item;
    pe1Key = null;
    pe2Key = null;
    pSubEKey = null;
    namePE1Controller.clear();
    namePE2Controller.clear();
    namePSubEController.clear();
    notifyListeners();
  }

  void onTapPE1Key(SearchFieldListItem<String> p1) {
    if (p1.item == pe1Key) return;
    pe1Key = p1.item;
    pe2Key = null;
    pSubEKey = null;
    namePE2Controller.clear();
    namePSubEController.clear();
    notifyListeners();
  }

  void onTapPE2Key(SearchFieldListItem<String> p1) {
    if (p1.item == pe2Key) return;
    pe2Key = p1.item;
    pSubEKey = null;
    namePSubEController.clear();
    notifyListeners();
  }

  void onTapPSubEKey(SearchFieldListItem<String> p1) {
    if (p1.item == pSubEKey) return;
    if (p1.item!.contains(".")) {
      final items = p1.item!.split(".");
      ps1Key = items[1];
      ps2Key = items[2];
      pe1Key = items[3];
      pe2Key = items[4];
      pSubEKey = items[5];
      // Set the text controllers
      String prefix = '$ps0Key.$ps1Key';
      namePS1Controller.text = '$prefix ${ps1Suggestions[ps1Key]!['name']}';
      prefix = '$prefix.$ps2Key';
      namePS2Controller.text = '$prefix ${ps2Suggestions[ps2Key]!['name']}';
      prefix = '$prefix.$pe1Key';
      namePE1Controller.text = '$prefix ${pe1Suggestions[pe1Key]!['name']}';
      prefix = '$prefix.$pe2Key';
      namePE2Controller.text = '$prefix ${pe2Suggestions[pe2Key]!['name']}';
      notifyListeners();
      return;
    }
    pSubEKey = p1.item;
    notifyListeners();
  }

  List<Map<String, dynamic>> projectsList = [
    {
      "NAME": "DINCYDET",
      "ID": -1,
    }
  ];
  void getProjectsList() async {
    final projects = await apiProjectsGetList();
    if (projects != null) {
      projectsList.addAll(projects);
      notifyListeners();
    }
  }

  int? projectKey;
  void onTapProjectKey(SearchFieldListItem<int> p1) {
    if (p1.item == projectKey) return;
    projectKey = p1.item;
    notifyListeners();
  }

  File? pickedFile;
  void onTapAddFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
    );
    if (result == null) return;
    pickedFile = File(result.files.single.path!);
    notifyListeners();
  }
}
