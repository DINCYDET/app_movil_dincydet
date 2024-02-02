import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/tickets/newticket_provider.dart';

import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterTicketView extends StatelessWidget {
  const RegisterTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Nuevo Ticket',
      drawer: false,
      section: DrawerSection.other,
      body: ChangeNotifierProvider<NewTicketProvider>(
        create: (context) => NewTicketProvider(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20,
          ),
          child: Card(
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<NewTicketProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'DATOS',
                            style: TextStyle(
                              color: MC_darkblue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormField(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                label: Text('Ticket'),
                                icon: Icon(
                                  Icons.credit_card_outlined,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: provider.ttypesel,
                                  items: provider.ttypeitems
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.name),
                                          ))
                                      .toList(),
                                  isDense: true,
                                  onChanged: ((value) {
                                    provider.onDropdownChange(
                                      value!,
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InputDecorator(
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text('Adjuntar archivo'),
                            icon: Icon(
                              Icons.file_present,
                              size: 36,
                              color: MC_darkblue,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          child: InkWell(
                            onTap: provider.pickFile,
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              alignment: Alignment.center,
                              child: provider.pickedFile != null
                                  ? Text(provider.fileName)
                                  : const Text(
                                      'Seleccione un archivo',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: provider.nameController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.dashboard_outlined,
                              size: 36,
                              color: MC_darkblue,
                            ),
                            label: Text('Nombre'),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AspectRatio(
                          aspectRatio: 3,
                          child: TextField(
                            controller: provider.descController,
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.file_copy_sharp,
                                size: 36,
                                color: MC_darkblue,
                              ),
                              label: Text('Descripcion'),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: provider.username,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.people,
                              size: 36,
                              color: MC_darkblue,
                            ),
                            label: Text('Enviar a'),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          readOnly: true,
                          onTap: provider.onTapSendTo,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InputDecorator(
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text('Prioridad'),
                            icon: Icon(
                              Icons.cases_rounded,
                              size: 36,
                              color: MC_darkblue,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: provider.priority,
                              items: List.generate(provider.priorities.length,
                                  (index) {
                                return DropdownMenuItem(
                                  value: index,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                            provider.priorities[index]['name']),
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: provider.priorities[index]
                                            ['color'],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              isDense: true,
                              onChanged: provider.priorityChange,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: provider.isProject,
                          child: Column(
                            children: [
                              TextField(
                                controller: provider.prjname,
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.dashboard_customize,
                                    size: 36,
                                    color: MC_darkblue,
                                  ),
                                  label: Text('Proyecto'),
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
                                        'Proyectos',
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
                                      data: provider.prjsuggestions,
                                      selectedItems:
                                          (List<dynamic> selectedList) {
                                        for (var item in selectedList) {
                                          provider.onTapProject(
                                            item.name,
                                            item.value,
                                          );
                                        }
                                      },
                                      enableMultipleSelection: false,
                                    ),
                                  ).showModal(context);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Tarea:',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                      value: provider.allowTask,
                                      onChanged: (val) {
                                        provider.onTapCheckTasks(val!);
                                        print(val);
                                      }),
                                  const Spacer(),
                                  const Text(
                                    'Subtarea:',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                      value: provider.allowSubTask,
                                      onChanged: (val) {
                                        provider.onTapCheckSubTasks(val!);
                                      }),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: provider.taskname,
                                decoration: InputDecoration(
                                  enabled: provider.allowTask,
                                  icon: const Icon(
                                    Icons.dashboard_customize,
                                    size: 36,
                                    color: MC_darkblue,
                                  ),
                                  label: const Text('Tarea'),
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                ),
                                readOnly: true,
                                onTap: () {
                                  DropDownState(
                                    DropDown(
                                      dropDownBackgroundColor:
                                          const Color(0xFFFBFBFB),
                                      bottomSheetTitle: const Text(
                                        'Tareas',
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
                                      data: provider.tasksuggestions,
                                      selectedItems:
                                          (List<dynamic> selectedList) {
                                        for (var item in selectedList) {
                                          provider.onTapTask(
                                            item.name,
                                            item.value,
                                          );
                                        }
                                      },
                                      enableMultipleSelection: false,
                                    ),
                                  ).showModal(context);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: provider.subtaskname,
                                decoration: InputDecoration(
                                  enabled: provider.allowSubTask,
                                  icon: const Icon(
                                    Icons.dashboard_customize,
                                    size: 36,
                                    color: MC_darkblue,
                                  ),
                                  label: const Text('Sub-Tarea'),
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                ),
                                readOnly: true,
                                onTap: () {
                                  DropDownState(
                                    DropDown(
                                      dropDownBackgroundColor:
                                          const Color(0xFFFBFBFB),
                                      bottomSheetTitle: const Text(
                                        'Sub-Tareas',
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
                                      data: provider.subtasksuggestions,
                                      selectedItems:
                                          (List<dynamic> selectedList) {
                                        for (var item in selectedList) {
                                          provider.onTapSubTask(
                                            item.name,
                                            item.value,
                                          );
                                        }
                                      },
                                      enableMultipleSelection: false,
                                    ),
                                  ).showModal(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: MC_lightblue,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Descartar',
                                  style: TextStyle(fontSize: 18)),
                            ),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: MC_lightblue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: provider.sendTicket,
                              child: const Text('Generar Ticket',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
