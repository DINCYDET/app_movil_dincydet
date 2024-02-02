import 'dart:io';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetReportPage extends StatelessWidget {
  const BudgetReportPage({
    super.key,
    required this.budgetData,
    required this.codesMap,
  });
  final List<Map<String, dynamic>> budgetData;
  final dynamic codesMap;
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Reporte de presupuesto',
      section: DrawerSection.other,
      drawer: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      onPressed: makeExcel,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: [
                    Expanded(
                      child: DataTable(
                        horizontalMargin: 0.0,
                        columnSpacing: 20.0,
                        columns: headers
                            .map(
                              (e) => DataColumn(
                                label: Text(
                                  e,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        rows: budgetData.map((e) {
                          final isProject = e['ISPROJECT'];
                          final name = isProject ? e['FROMNAME'] : 'DINCYDET';
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(name),
                              ),
                              DataCell(
                                Text(e['DEPARTURE'] ?? ''),
                              ),
                              DataCell(
                                Text(
                                  descriptionFromCode(e['DEPARTURE']),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Text(e['AMOUNT'].toString()),
                              ),
                              const DataCell(
                                Text(''),
                              ),
                              const DataCell(
                                Text(''),
                              ),
                              const DataCell(
                                Text(''),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> headers = const [
    'SOLICITANTE',
    'CLASIFICADOR',
    'DESCRIPCION',
    'ASIGNACION ANUAL',
    'CERTIFICADO COMPROMETIDO',
    'DEVENGADO',
    'GIRADO'
  ];

  void makeExcel() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    // Set the headers for columns ['Clasificador', 'Descripcion', 'ASIGNACION ANUAL', 'CERTIFICADO PROMETIDO', 'DEVENGADO', 'GIRADO']
    sheetObject.appendRow(headers);
    // Add the data
    for (var item in budgetData) {
      String name = item['FROMNAME'];
      if (item['ISPROJECT'] == false) name = 'DINCYDET';
      sheetObject.appendRow([
        name,
        item['DEPARTURE'],
        descriptionFromCode(item['DEPARTURE']),
        item['AMOUNT'],
        '',
        '',
        ''
      ]);
    }
    // Set auto width for columns
    for (var i = 0; i < 6; i++) {
      sheetObject.setColAutoFit(i);
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .cellStyle = CellStyle(
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        fontColorHex: '#000000',
        backgroundColorHex: '#FFFFFF',
      );
    }

    // Show a dialog to user enter name and location of the file
    // Save the file
    String? directory =
        await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
    if (directory == null) return;
    String fileName = 'Reporte de presupuesto.xlsx';
    // Add datetime to the file name
    String now = DateFormat('yyyy-MM-dd HH-mm-ss').format(DateTime.now());
    fileName = '$now $fileName';
    var excelBytes = excel.save();
    if (excelBytes == null) return;
    File('$directory/$fileName')
      ..createSync(recursive: true)
      ..writeAsBytesSync(
        excelBytes,
      );
    // Show a dialog to user that the file was saved
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Archivo guardado'),
        content: Text('El archivo se guardo en $directory'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String descriptionFromCode(String? code) {
    if (code == null) return '';
    final splitted = code.split('.');
    if (splitted.length == 1) return '';
    dynamic item;
    for (var i = 0; i < splitted.length; i++) {
      if (i == 0) {
        item = codesMap[splitted[i]];
      } else {
        item = item['children'][splitted[i]];
      }
    }
    return item['name'] ?? '';
  }
}
