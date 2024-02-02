import 'dart:io';

import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/previews/pdfviewer.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PersonalProvider extends ChangeNotifier {
  PersonalProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadDailyPart();
    });
  }

  Map<int, List> dailyPart = {
    0: [],
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
    9: [],
  };

  List<String> summaryLabels = [
    'Presentes',
    'Permiso',
    'Vacaciones',
    'Comisión',
    'Guardia',
    'Destacado del',
    'Hospitalizado',
    'Descanso Médico',
    'Exonerado',
    'Falto',
  ];

  void validateHour() {
    DateTime now = DateTime.now();
    // Compare if now is after 8:00
    if ((now.hour <= 8 && now.minute < 30) || isGenerated == false) {
      // Show a dialog that says that the report is not generated yet
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Reporte no generado'),
          content: const Text(
              'El reporte no ha sido generado aún, por favor espere hasta las 8:30 para generar el reporte.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  bool isGenerated = false;

  void loadDailyPart() async {
    final data = await apiAssistanceGetDaily();
    if (data == null) {
      return;
    }
    isGenerated = data.isNotEmpty;
    for (var element in data) {
      dailyPart[element['TYPE']]?.add(element['USERDATA']);
    }
    validateHour();
    notifyListeners();
  }

  String get nowDate {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('dd/MM/yyyy');
    return format.format(now);
  }

  List<Map<String, dynamic>> get summary {
    List<Map<String, dynamic>> summary = [];
    final Map<String, dynamic> efectives = {
      'name': 'EFECTIVOS',
      'PERSUPE': 0,
      'PERSUBA': 0,
      'PERMAR': 0,
      'PERCIVI': 0,
      'TOTAL': 0,
    };
    for (var i = 0; i < summaryLabels.length; i++) {
      final Map<String, dynamic> data = {
        'name': summaryLabels[i].toUpperCase(),
        'PERSUPE': 0,
        'PERSUBA': 0,
        'PERMAR': 0,
        'PERCIVI': 0,
        'TOTAL': 0,
      };
      final items = dailyPart[i]!;
      for (var item in items) {
        int grade = item['GRADEID'];
        if (isPersupe(grade)) {
          data['PERSUPE']++;
          efectives['PERSUPE']++;
        } else if (isPersuba(grade)) {
          data['PERSUBA']++;
          efectives['PERSUBA']++;
        } else if (isPermar(grade)) {
          data['PERMAR']++;
          efectives['PERMAR']++;
        } else if (isPercivi(grade)) {
          data['PERCIVI']++;
          efectives['PERCIVI']++;
        }
      }
      data['TOTAL'] =
          data['PERSUPE'] + data['PERSUBA'] + data['PERMAR'] + data['PERCIVI'];
      summary.add(data);
    }
    efectives['TOTAL'] = efectives['PERSUPE'] +
        efectives['PERSUBA'] +
        efectives['PERMAR'] +
        efectives['PERCIVI'];
    // Copy efectives to a new variable
    final Map<String, dynamic> total = Map.from(efectives);
    total['name'] = 'TOTAL';
    summary.add(total);
    summary.insert(0, efectives);
    return summary;
  }

  bool isPersupe(int gradeId) {
    return gradeId <= 7;
  }

  bool isPersuba(int gradeId) {
    return gradeId >= 8 && gradeId < 17;
  }

  bool isPermar(int gradeId) {
    return gradeId >= 17 && gradeId < 20;
  }

  bool isPercivi(int gradeId) {
    return gradeId == 20;
  }

  void onTapExport() async {
    // Export data to PDF and show in viewer
    final pdf = pw.Document();
    // Data for row construction
    final List<String> headers = [
      'CONDICIONES',
      'PERSUPE',
      'PERSUBA',
      'PERMAR',
      'PERCIVI',
      'TOTAL',
    ];

    final data = summary;

    // Format date as long format (e.g. LUNES, 12 de ENERO de 2021)
    initializeDateFormatting('es', null);
    final String formattedDate =
        DateFormat.yMMMMEEEEd('es').format(DateTime.now());

    // Format time as long format (e.g. 8:25:56 PM)
    final String formattedTime = DateFormat.jms().format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(
                'DIRECCIÓN DE INVESTIGACIÓN CIENTÍFICA Y DESARROLLO\nTECNOLÓGICO DE LA MARINA',
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                'OFICINA DE PERSONAL',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ]),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'PARTE DIARIO DE 08:30 HRS\nDIRECCIÓN DE INVESTIGACIÓN CIENTÍFICA Y DESARROLLO\nTECNOLÓGICO DE LA MARINA',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            // TODO: Add table
            pw.Row(children: [
              pw.Expanded(
                child: pw.Table(
                  children: [
                    pw.TableRow(
                      children: headers
                          .map(
                            (header) => pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                header,
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    ...data.map(
                      (row) => pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['name'].toString(),
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['PERSUPE'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['PERSUBA'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['PERMAR'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['PERCIVI'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              row['TOTAL'].toString(),
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  border: pw.TableBorder.all(),
                ),
              ),
            ]),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'FECHA: $formattedDate',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ),
            pw.SizedBox(height: 50),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 50.0),
              alignment: pw.Alignment.centerRight,
              child: pw.Column(children: [
                pw.Text(
                  '__________________________',
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  'JEFE DE PERSONAL',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),
              ]),
            ),
          ]); // Center
        },
      ),
    );

    // User presence list detailed by type

    final Map<String, Map<int, List<dynamic>>> usersClassified = {
      'PERSONAL SUPERIOR': Map<int, List<dynamic>>.from(dailyPart),
      'PERSONAL SUBALTERNO': Map<int, List<dynamic>>.from(dailyPart),
      'PERSONAL MARINERÍA': Map<int, List<dynamic>>.from(dailyPart),
      'PERSONAL CIVIL': Map<int, List<dynamic>>.from(dailyPart),
    };
    for (int i = 0; i < dailyPart.length; i++) {
      usersClassified['PERSONAL SUPERIOR']![i] =
          usersClassified['PERSONAL SUPERIOR']![i]!
              .where((element) => isPersupe(element['GRADEID']))
              .toList();
      usersClassified['PERSONAL CIVIL']![i] =
          usersClassified['PERSONAL CIVIL']![i]!
              .where((element) => isPercivi(element['GRADEID']))
              .toList();
      usersClassified['PERSONAL SUBALTERNO']![i] =
          usersClassified['PERSONAL SUBALTERNO']![i]!
              .where((element) => isPersuba(element['GRADEID']))
              .toList();
      usersClassified['PERSONAL MARINERÍA']![i] =
          usersClassified['PERSONAL MARINERÍA']![i]!
              .where((element) => isPermar(element['GRADEID']))
              .toList();
    }

    usersClassified['PERSONAL SUPERIOR']!
        .removeWhere((key, value) => value.isEmpty);
    usersClassified['PERSONAL CIVIL']!
        .removeWhere((key, value) => value.isEmpty);
    usersClassified['PERSONAL SUBALTERNO']!
        .removeWhere((key, value) => value.isEmpty);
    usersClassified['PERSONAL MARINERÍA']!
        .removeWhere((key, value) => value.isEmpty);
    usersClassified['PERSONAL SUPERIOR']!.remove(0);
    usersClassified['PERSONAL CIVIL']!.remove(0);
    usersClassified['PERSONAL SUBALTERNO']!.remove(0);
    usersClassified['PERSONAL MARINERÍA']!.remove(0);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Align(
              alignment: pw.Alignment.topCenter,
              child: pw.Text(
                'DEMOSTRATIVO',
                style: const pw.TextStyle(
                  decoration: pw.TextDecoration.underline,
                  fontSize: 10,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                'FECHA: ${formattedDate.toUpperCase()}',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: List.generate(usersClassified.length, (index) {
                final String key = usersClassified.keys.elementAt(index);
                final Map<int, List<dynamic>> data = usersClassified[key]!;
                return pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Align(
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text(
                        key.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    for (int i in data.keys)
                      pw.Flexible(
                        child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                '${personalTypes[i].toUpperCase()}: ${data[i]!.length}',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.SizedBox(
                                //x: number of rows
                                //18 -> height container, 6 -> main axis spacing
                                //total height = 18x + 6(x-1) = 24x - 6
                                height: (24 *
                                        ((data[i]!.length / 3).ceil())
                                            .toDouble()) -
                                    6,
                                child: pw.GridView(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 6,
                                  crossAxisSpacing: 8,
                                  children: [
                                    for (var item in data[i]!)
                                      pw.Text(
                                        item['FULLNAME'],
                                        // maxLines: 2,
                                        style: const pw.TextStyle(
                                            fontSize: 8, height: 1),
                                      ),
                                  ],
                                )),
                            pw.SizedBox(height: 5),
                          ],
                        ),
                      ),
                    pw.SizedBox(height: 10),
                  ],
                );
              }),
            ),
          ];
        },
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Hora: $formattedTime',
            // style: pw.Theme.of(context)
            //     .defaultTextStyle
            //     .copyWith(color: PdfColors.grey),
          ),
        ),
      ),
    );

    // TODO: Show PDF in viewer
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/parte.pdf');
    await file.writeAsBytes(await pdf.save());
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => PDFViewer(pdf: file),
      ),
    );
  }
}
