import 'dart:io';
import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketsview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class TicketsViewProvider extends ChangeNotifier {
  List<Widget> childrenin = [];
  List<Widget> childrenout = [];

  TicketsViewProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPressed();
    });
  }

  void onPressed() async {
    int dni = 0; // TODO: Get dni from provider
    Map<String, dynamic>? response = await apiTicketsGetIn(dni);
    if (response != null) {
      final data = response['tickets'] as List<dynamic>;
      childrenin = data.map((e) {
        return TicketCardT1(
          data: e,
          saveFile: saveFile,
          viewFile: viewFile,
        );
      }).toList();
    }
    response = await apiTicketsGetOut(dni);
    if (response != null) {
      final data = response['tickets'] as List<dynamic>;
      childrenout = data.map((e) {
        return TicketCardT2(
          data: e,
          saveFile: saveFile,
          viewFile: viewFile,
        );
      }).toList();
    }
    notifyListeners();
  }

  Future<String> getDocsPath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    return appDocumentsPath;
  }

  void saveFile(String filename, BuildContext context) async {
    try {
      Response<dynamic> response = await Dio().get(
        //'${apiBase}uploads/tickets/$filename',
        filename,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      String path = await getDocsPath();
      File file = File(join(path, filename));
      file.writeAsBytes(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descarga completa: ${file.path}'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void viewFile(String filename, String filetype, BuildContext context) async {
    //final String extension = filename.split('.')[1];
    //TODO: Pass data in provider
    if (filetype == 'img') {
      Navigator.of(context).pushNamed('/previewimg');
    } else if (filetype == 'pdf') {
      Navigator.of(context).pushNamed('/previewpdf');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede visualizar'),
        ),
      );
    }
  }
}
