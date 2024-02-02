import 'dart:io';

import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/src/utils/userinfo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

class Previewpdf extends StatelessWidget {
  const Previewpdf({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArguments;
    final String imgurl = args.other;
    print(imgurl);
    try {
      late Future<PdfDocument> doc;
      if (imgurl.startsWith('http')) {
        doc = PdfDocument.openData(
          InternetFile.get(imgurl),
          //InternetFile.get('${apiBase}uploads/tickets/$imgurl'),
        );
      } else if (imgurl.startsWith('LF:')) {
        doc = PdfDocument.openFile(imgurl.substring(3));
      } else {
        doc = PdfDocument.openData(
          InternetFile.get(imgurl),
          //InternetFile.get('${apiBase}uploads/tickets/$imgurl'),
        );
      }
      final pdfController = PdfController(document: doc);
      return MyScaffold(
        title: 'PDF Generado',
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
                    child: const Icon(Icons.share),
                    onPressed: () async {
                      if (imgurl.startsWith('LF:')) {
                        Share.shareXFiles([XFile(imgurl.substring(3))]);
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.download),
                    onPressed: () async {
                      String filename = DateTime.now().toString();
                      filename = filename.replaceAll(':', '-');
                      filename = filename.replaceAll('.', '-');
                      filename = filename.replaceFirst(' ', '_');
                      filename = "$filename.pdf";
                      print(filename);
                      String? outputFile = await FilePicker.platform.saveFile(
                        dialogTitle: 'Please select an output file:',
                        fileName: filename,
                      );
                      if (outputFile == null) {
                        return;
                      }
                      if (imgurl.startsWith('LF:')) {
                        final File file = File(imgurl.substring(3));
                        await file.copy(outputFile);
                      }
                    },
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
    } catch (_) {
      return const MyScaffold(
        title: 'PDF Generado',
        section: DrawerSection.other,
        drawer: false,
        body: Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      );
    }
  }
}
