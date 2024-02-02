import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class ProjectEditDialog extends StatefulWidget {
  const ProjectEditDialog({
    super.key,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectManagerName,
    required this.users,
    required this.navalForce,
  });

  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String navalForce;

  final String projectManagerName;
  final List<SelectedListItem> users;

  @override
  State<ProjectEditDialog> createState() => _ProjectEditDialogState();
}

class _ProjectEditDialogState extends State<ProjectEditDialog> {
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newNavalForceController = TextEditingController();
  final TextEditingController newDescriptionController =
      TextEditingController();
  final TextEditingController newStartDateController = TextEditingController();
  final TextEditingController newEndDateController = TextEditingController();
  final TextEditingController newProjectManagerController =
      TextEditingController();
  int? newManagerid;
  int? newNavalForceId;

  @override
  void initState() {
    newNameController.text = widget.name;
    newDescriptionController.text = widget.description;
    newStartDateController.text = widget.startDate;
    newEndDateController.text = widget.endDate;
    newProjectManagerController.text = widget.projectManagerName;
    newNavalForceController.text = widget.navalForce;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Editar proyecto'),
      contentPadding: const EdgeInsets.all(10.0),
      children: [
        SizedBox(
          width: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: newNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Nombre del proyecto'),
                  isDense: true,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: newNavalForceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Dependencia o Fuerza Naval'),
                  isDense: true,
                ),
                onTap: () {
                  DropDownState(
                    DropDown(
                      bottomSheetTitle:
                          const Text('Dependencia o Fuerza Naval'),
                      data: List.generate(dependencies.length, (index) {
                        return SelectedListItem(
                          name: dependencies[index],
                          value: index.toString(),
                        );
                      }),
                      selectedItems: (items) {
                        for (SelectedListItem item in items) {
                          newNavalForceId = int.parse(item.value!);
                          newNavalForceController.text = item.name;
                          return;
                        }
                      },
                    ),
                  ).showModal(context);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: newProjectManagerController,
                readOnly: true,
                onTap: () {
                  DropDownState(
                    DropDown(
                      bottomSheetTitle: const Text('Usuarios'),
                      data: widget.users,
                      selectedItems: (items) {
                        for (SelectedListItem item in items) {
                          newManagerid = int.parse(item.value!);
                          newProjectManagerController.text = item.name;

                          return;
                        }
                      },
                    ),
                  ).showModal(navigatorKey.currentContext!);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Jefe de proyecto'),
                  isDense: true,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newStartDateController,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Fecha de inicio'),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: newEndDateController,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Fecha de fin'),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                minLines: 4,
                maxLines: 8,
                controller: newDescriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Descripcion del proyecto'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: MC_darkblue,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void onTapAccept() {
    final dataMap = <String, dynamic>{
      'NAME': newNameController.text,
      'DESCRIPTION': newDescriptionController.text,
    };
    if (newManagerid != null) {
      dataMap['LEADID'] = newManagerid;
      dataMap['LEADNAME'] = newProjectManagerController.text;
    }
    if (newNavalForceId != null) {
      dataMap['NAVALFORCEID'] = newNavalForceId;
      dataMap['NAVALFORCENAME'] = newNavalForceController.text;
    }
    Navigator.pop(context, dataMap);
  }
}
