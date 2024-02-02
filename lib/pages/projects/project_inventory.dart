import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_detail.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_tables.dart';
import 'package:flutter/material.dart';

class ProjectInventoryDialog extends StatelessWidget {
  const ProjectInventoryDialog({
    super.key,
    required this.data,
    required this.projectsList,
  });

  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> projectsList;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: max(700, widthDevice*0.7-40),
            height: MediaQuery.of(context).size.height * 0.6,
            child: InventoryTable(
              data: data,
              onTapDelete: onTapDelete,
              onTapEdit: onTapEdit,
              onTapDetail: onTapDetails,
            ),
          ),
        )
      ],
    );
  }

  void onTapDetails(int index) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return InventoryDetailDialog(
          projectsList: projectsList,
          data: data[index],
        );
      },
    );
  }
  void onTapDelete(int index) {
    // Show dialog that explains that delete is disabled in this view
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text(
              'No se puede eliminar en esta vista, por favor, use la vista de inventario'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void onTapEdit(int index) {
    // Show dialog that explains that edit is disabled in this view
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar'),
          content: const Text(
              'No se puede editar en esta vista, por favor, use la vista de inventario'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
