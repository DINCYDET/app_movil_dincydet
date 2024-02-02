import 'package:app_movil_dincydet/pages/projects/widgets/labels.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/tasks_subtasks_class.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/timepicker.dart';
import 'package:app_movil_dincydet/providers/projects/addonproject_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.data, required this.i});
  final TaskData data;
  final int i;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.arrow_drop_down,
              color: MC_lightblue,
            ),
            Text(
              'Tarea ${i + 1}',
              style: const TextStyle(
                color: MC_lightblue,
                fontSize: 17,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Consumer<AddonProjectProvider>(
              builder: (context, provider, child) {
                return TextButton(
                  onPressed: () {
                    provider.removeTask(i);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: MC_darkred,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: MC_darkred,
                      ),
                    ),
                  ),
                  child: const Text('Eliminar Tarea'),
                );
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextIconLabel2(
              label: 'Nombre de Tarea',
              letter: 'a',
              main: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: TextField(
                controller: data.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const TextIconLabel2(
              label: 'Duracion',
              letter: 'b',
              main: true,
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
                      controller: data.start,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TimePicker(
                      label: 'Fin',
                      controller: data.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextIconLabel2(
              label: 'Asignado a',
              letter: 'c',
              main: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Consumer<AddonProjectProvider>(
                builder: (context, provider, child) {
                  return TextField(
                    controller: data.username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    readOnly: true,
                    onTap: () {
                      DropDownState(
                        DropDown(
                          dropDownBackgroundColor:
                              const Color(0xFFFBFBFB),
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
                          data: provider.suggestions,
                          selectedItems: (List<dynamic> selectedList) {
                            for (var item in selectedList) {
                              data.username.text = item.name;
                              data.userid = int.parse(item.value);
                            }
                          },
                          enableMultipleSelection: false,
                        ),
                      ).showModal(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Consumer<AddonProjectProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(provider.subtasks[i].length, (j) {
                      return SubTaskWidget(
                        data: provider.subtasks[i][j],
                        i: i,
                        j: j,
                      );
                    }),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      provider.addSubTask(i);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('SubTarea'),
                  ),
                ],
              );
            },
          ),
        ),
        const Divider(
          height: 1.0,
          thickness: 2,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class SubTaskWidget extends StatelessWidget {
  const SubTaskWidget({
    super.key,
    required this.data,
    required this.i,
    required this.j,
  });
  final SubTaskData data;
  final int i;
  final int j;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_drop_down,
              color: MC_lightblueAccent,
            ),
            Text(
              'Sub-Tarea ${j + 1}',
              style: const TextStyle(
                color: MC_lightblueAccent,
                fontSize: 17,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Consumer<AddonProjectProvider>(
              builder: (context, provider, child) {
                return TextButton(
                  onPressed: () {
                    provider.removeSubTask(i, j);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: MC_darkred,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: MC_darkred,
                      ),
                    ),
                  ),
                  child: const Text('Eliminar Sub-tarea'),
                );
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextIconLabel2(
              label: 'Nombre de Sub-Tarea',
              letter: 'a',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: TextField(
                controller: data.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const TextIconLabel2(
              label: 'Duracion',
              letter: 'b',
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
                      controller: data.start,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TimePicker(
                      label: 'Fin',
                      controller: data.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextIconLabel2(
              label: 'Persona a cargo',
              letter: 'c',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Consumer<AddonProjectProvider>(
                builder: (context, provider, child) {
                  return TextField(
                    controller: data.username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    readOnly: true,
                    onTap: () {
                      DropDownState(
                        DropDown(
                          dropDownBackgroundColor:
                              const Color(0xFFFBFBFB),
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
                          data: provider.suggestions,
                          selectedItems: (List<dynamic> selectedList) {
                            for (var item in selectedList) {
                              data.username.text = item.name;
                              data.userid = int.parse(item.value);
                            }
                          },
                          enableMultipleSelection: false,
                        ),
                      ).showModal(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        const Divider(
          height: 1.0,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
