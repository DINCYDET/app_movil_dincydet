import 'package:app_movil_dincydet/providers/projects/newproject_provider.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/labels.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/tasks_subtasks_class.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/timepicker.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseProjectWidget extends StatelessWidget {
  const BaseProjectWidget({
    Key? key,
    required this.basedata,
  }) : super(key: key);

  final BaseData basedata;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextIconLabel(
              label: 'Nombre del proyecto',
              number: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: TextField(
                decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    )),
                controller: basedata.name,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const TextIconLabel(
              label: 'Duracion',
              number: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TimePicker(
                      label: 'Inicio',
                      controller: basedata.start,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TimePicker(
                      label: 'Fin',
                      controller: basedata.end,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const TextIconLabel(
              label: 'Descripcion del proyecto',
              number: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    )),
                controller: basedata.description,
              ),
            ),
            
            const TextIconLabel(
              label: 'Jefe del proyecto',
              number: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: TextField(
                controller: basedata.supername,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                readOnly: true,
                onTap: () {
                  DropDownState(
                    DropDown(
                      dropDownBackgroundColor: const Color(0xFFFBFBFB),
                      bottomSheetTitle: const Text(
                        'Usuarios',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      submitButtonChild: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      data: Provider.of<NewProjectProvider>(context,
                              listen: false)
                          .suggestions,
                      selectedItems: (List<dynamic> selectedList) {
                        for (var item in selectedList) {
                          basedata.supername.text = item.name;
                          basedata.superid = int.parse(item.value);
                        }
                      },
                      enableMultipleSelection: false,
                    ),
                  ).showModal(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
