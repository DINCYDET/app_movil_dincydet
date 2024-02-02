import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> generatePresentPDF(List<dynamic> data) async {
  final pdf = pw.Document();
  // Obtener imagen
  ByteData imgbytes = await rootBundle.load('assets/logo_back.png');
  Uint8List logobytes = imgbytes.buffer.asUint8List();
  List<List<String>> rows = [];
  for (var i = 0; i < data.length; i++) {
    final List line = data[i];
    if (!line[2]) {
      continue;
    }
    rows.add([
      line[1] + ' ' + line[0],
      'Si',
    ]);
  }
  final table = pw.Table.fromTextArray(
    border: pw.TableBorder.all(),
    headerStyle: pw.TextStyle(
      fontSize: 20,
      color: PdfColors.blue900,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      fontSize: 16,
    ),
    headers: [
      'Nombres y apellidos',
      'Asistio',
    ],
    data: rows,
  );
  final DateTime date = DateTime.now();
  final DateFormat dateformat = DateFormat.yMd().add_jm();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Text(
            'Parte del dia',
            style: const pw.TextStyle(color: PdfColors.blue900, fontSize: 40),
          ),
          pw.Divider(thickness: 4),
          table,
          pw.SizedBox(height: 10),
          pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('Fecha y hora: ${dateformat.format(date)}'))
        ]);
      },
      pageTheme: pw.PageTheme(
        pageFormat: const PdfPageFormat(
          21.0 * PdfPageFormat.cm,
          double.infinity,
          marginAll: 2.0 * PdfPageFormat.cm,
        ),
        buildBackground: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Container(
            margin: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.yellow200,
              ),
            ),
            child: pw.Image(pw.MemoryImage(logobytes)),
          ),
        ),
      ),
    ),
  );
  return pdf;
}

Future<pw.Document> generateAusentPDF(List<dynamic> data) async {
  final pdf = pw.Document();
  // Obtener imagen
  ByteData imgbytes = await rootBundle.load('assets/logo_back.png');
  Uint8List logobytes = imgbytes.buffer.asUint8List();
  List<List<String>> rows = [];
  for (var i = 0; i < data.length; i++) {
    final List line = data[i];
    if (line[2]) {
      continue;
    }
    String just = '-';
    if (line[3]) {
      just = 'Permiso';
    } else if (line[4]) {
      just = 'Hospital';
    } else if (line[5]) {
      just = 'Vacaciones';
    } else {
      just = 'No justificado';
    }
    rows.add([
      line[1] + ' ' + line[0],
      line[2] ? 'Si' : 'No',
      just,
    ]);
  }
  final table = pw.Table.fromTextArray(
    border: pw.TableBorder.all(),
    headerStyle: pw.TextStyle(
      fontSize: 20,
      color: PdfColors.blue900,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      fontSize: 16,
    ),
    headers: [
      'Nombres y apellidos',
      'Asistio',
      'Justificacion',
    ],
    data: rows,
  );
  final DateTime date = DateTime.now();
  final DateFormat dateformat = DateFormat.yMd().add_jm();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Text(
            'Parte del dia',
            style: const pw.TextStyle(color: PdfColors.blue900, fontSize: 40),
          ),
          pw.Divider(thickness: 4),
          table,
          pw.SizedBox(height: 10),
          pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('Fecha y hora: ${dateformat.format(date)}'))
        ]);
      },
      pageTheme: pw.PageTheme(
        pageFormat: const PdfPageFormat(
          21.0 * PdfPageFormat.cm,
          double.infinity,
          marginAll: 2.0 * PdfPageFormat.cm,
        ),
        buildBackground: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Container(
            margin: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.yellow200,
              ),
            ),
            child: pw.Image(pw.MemoryImage(logobytes)),
          ),
        ),
      ),
    ),
  );
  return pdf;
}
