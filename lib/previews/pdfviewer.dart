import 'dart:io';

import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({
    super.key,
    required this.pdf,
  });
  final File pdf;

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late PdfController pdfController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdf.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Visor PDF',
      section: DrawerSection.other,
      drawer: false,
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onTapShare,
                  child: const Icon(Icons.share),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onTapDownloadFile,
                  child: const Icon(Icons.download),
                ),
              ],
            ),
          ),
          Expanded(
            child: PdfView(
              controller: pdfController,
            ),
          ),
        ],
      ),
    );
  }

  void onTapShare() async {
    // Show a message that explains the sharing feature is not available
    // await Share.share('texto compartido desde flutter!');
    final String now = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final directory = await getTemporaryDirectory();
    File savedFile = File('${directory.path}/Parte_diario_$now.pdf');

    try {
      await savedFile.writeAsBytes(await widget.pdf.readAsBytes());
       await Share.shareXFiles([XFile(savedFile.path)]);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error, inténtelo de nuevo.'),
        ),
      );
      return;
    }
  }

  void onTapDownloadFile() async {
    // Query the user for download location

    final String now = DateFormat('dd-MM-yyyy').format(DateTime.now());

    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory == null) return;

    File savedFile = File('$directory/Parte diario $now.pdf');
    await savedFile.writeAsBytes(await widget.pdf.readAsBytes());

    // Show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF guardado en ${savedFile.path}'),
      ),
    );
  }
}
