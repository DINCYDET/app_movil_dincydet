import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_charts.dart';
import 'package:app_movil_dincydet/pages/projects/project_budget.dart';
import 'package:app_movil_dincydet/pages/projects/tasksbottom.dart';
import 'package:app_movil_dincydet/src/utils/user_photo.dart';
import 'package:app_movil_dincydet/utils/mywidgets/filesgrid.dart';
import 'package:app_movil_dincydet/providers/projects/projectdetail_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Proyecto',
      drawer: false,
      section: DrawerSection.other,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: ChangeNotifierProvider<ProjectDetailProvider>(
            create: (context) => ProjectDetailProvider(),
            child: Consumer<ProjectDetailProvider>(
                builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        const Text(
                          'Datos Generales',
                          style: TextStyle(
                            color: Color(0xFF0096C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: provider.onTapEditData,
                          child: const Icon(
                            Icons.edit,
                            color: Color(0xFF0096C7),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Container(
                              height: 1,
                              color: const Color(0xFF0096C7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: provider.nameController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Nombre del proyecto'),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: provider.navalForceController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Dependencia o Fuerza Naval'),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: provider.userNameController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Jefe de proyecto'),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: provider.startDateController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Inicio'),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: provider.endDateController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Final'),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  minLines: 3,
                                  maxLines: 8,
                                  readOnly: true,
                                  controller: provider.descriptionController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Descripcion del proyecto'),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Avance:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF535E78),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(0.1, 0.1),
                                      ),
                                    ],
                                  ),
                                  child: Progresso(
                                    progressColor: const Color(0xFFCA8D32),
                                    progress: provider.advance.toDouble() / 100,
                                    progressStrokeCap: StrokeCap.square,
                                    backgroundStrokeCap: StrokeCap.square,
                                    progressStrokeWidth: 11,
                                    backgroundStrokeWidth: 11,
                                    backgroundColor: const Color(0xFFD9D9D9),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${provider.advance}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF535E78),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: provider.onTapComplete,
                                child: const Text('Completado'),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF6251A2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: provider.onTapInventory,
                                child: const Text('Inventario'),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: MC_darkblue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: provider.onpushEdit,
                                child: const Text('Editar Tareas'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: provider.pickedUserController,
                                  readOnly: true,
                                  onTap: provider.onTapUser,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Agregar miembro'),
                                    hintText: 'Seleccionar',
                                    isDense: true,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: MC_darkblue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: provider.onTapAddMember,
                                child: const Text('Agregar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Información',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF7E0F08),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF7E0F08),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DefaultTabController(
                        length: 6,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: max(850, widthDevice - 60),
                                color: Colors.grey.shade100,
                                child: const TabBar(
                                  labelColor: Colors.blue,
                                  indicatorColor: Colors.blue,
                                  indicator: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  tabs: [
                                    Tab(
                                      text: 'Foto',
                                    ),
                                    Tab(
                                      text: 'Video',
                                    ),
                                    Tab(
                                      text: 'Integrantes',
                                    ),
                                    Tab(
                                      text: 'Informacion tecnica',
                                    ),
                                    Tab(
                                      text: 'Notas',
                                    ),
                                    Tab(
                                      text: 'Presupuesto',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 350,
                              child: TabBarView(
                                children: [
                                  FilesGrid(
                                    data:
                                        provider.files[ProjectFileType.image]!,
                                    onTapAdd: () => provider
                                        .onTapAdd(ProjectFileType.image),
                                    onTapDelete: provider.onTapDeleteFile,
                                  ),
                                  FilesGrid(
                                    data:
                                        provider.files[ProjectFileType.video]!,
                                    onTapAdd: () => provider
                                        .onTapAdd(ProjectFileType.video),
                                    onTapDelete: provider.onTapDeleteFile,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: List.generate(
                                          provider.members.length, (index) {
                                        final thismember =
                                            provider.members[index];
                                        return UserMemberRow(
                                          name: thismember['USERDATA']
                                              ['FULLNAME'],
                                          photo: thismember['USERDATA']
                                              ['PHOTO'],
                                          index: index,
                                          onTapDelete:
                                              provider.onTapDeleteMember,
                                        );
                                      }),
                                    ),
                                  ),
                                  FilesGrid(
                                    data: provider.files[ProjectFileType.info]!,
                                    onTapAdd: () =>
                                        provider.onTapAdd(ProjectFileType.info),
                                    onTapDelete: provider.onTapDeleteFile,
                                  ),
                                  FilesGrid(
                                    data: provider.files[ProjectFileType.txt]!,
                                    onTapAdd: () =>
                                        provider.onTapAdd(ProjectFileType.txt),
                                    onTapDelete: provider.onTapDeleteFile,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: max(700, widthDevice - 60),
                                      child: ProjectBudgetTable(
                                        budgetData: provider.budgetData,
                                        onTapDetails:
                                            provider.onTapBudgetDetails,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tickets Atendidos',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF1D154A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF1D154A),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: provider.totaltickets > 0
                              ? BarChart(
                                  BarChartData(
                                    barGroups: [
                                      BarChartGroupData(
                                        x: 0,
                                        barRods: [
                                          BarChartRodData(
                                            fromY: 0,
                                            toY: provider.tdata['OPEN'] * 1.0,
                                            color: const Color(0xFFBB271A),
                                            width: 30,
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                            fromY: 0,
                                            toY:
                                                provider.tdata['PROCESS'] * 1.0,
                                            color: const Color(0xFF0F4C81),
                                            width: 30,
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 2,
                                        barRods: [
                                          BarChartRodData(
                                            fromY: 0,
                                            toY: provider.tdata['CLOSE'] * 1.0,
                                            color: const Color(0xFF1E7E34),
                                            width: 30,
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ],
                                      ),
                                    ],
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    gridData: FlGridData(
                                      show: false,
                                    ),
                                    titlesData: FlTitlesData(
                                      show: false,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No hay tickets',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: LabelIndicator(
                                  color: const Color(0xFFBB271A),
                                  label: 'Abiertos',
                                  value: provider.tdata['OPEN'],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: LabelIndicator(
                                  color: const Color(0xFF0F4C81),
                                  label: 'En proceso',
                                  value: provider.tdata['PROCESS'],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: LabelIndicator(
                                  color: const Color(0xFF1E7E34),
                                  label: 'Cerrados',
                                  value: provider.tdata['CLOSE'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Resumen del Cronograma de Trabajo',
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFFC98C31),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFC98C31),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Card(
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: provider.onTapGeneralTasks,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: MC_darkblue,
                                  ),
                                  child: const Text('General'),
                                ),
                                OutlinedButton(
                                  onPressed: provider.onTapGanttTasks,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: MC_darkblue,
                                  ),
                                  child: const Text('Diagrama de Gantt'),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: provider.onTapExportGantt,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: MC_darkblue,
                                  ),
                                  child: const Text('Exportar'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: !provider.ganttSelected,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: max(500, widthDevice - 88),
                                        child: BottomTaskList(
                                          data: provider
                                              .data, // FIXME: Data contains more fields than needed
                                          factor: 1.0,
                                          allowEdit: true,
                                          onTapSetSubTask:
                                              provider.onTapSetSubTask,
                                          onTapSetTask: provider.onTapSetTask,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: provider.ganttSelected,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: max(480, widthDevice - 88),
                                        child: GanttChartView(
                                          showDays: true,
                                          showStickyArea: true,
                                          eventHeight: 75,
                                          startOfTheWeek: WeekDay.monday,
                                          weekEnds: const {
                                            WeekDay.saturday,
                                            WeekDay.sunday,
                                          },
                                          stickyAreaEventBuilder: (context,
                                              eventIndex, event, eventColor) {
                                            return Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: eventColor,
                                                border: Border.all(),
                                                // borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      event.displayName!,
                                                      maxLines: 3,
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          events: provider.events,
                                          startDate: provider.ganttStartDate,
                                          maxDuration: provider.ganttDuration,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

//TODO: Move the code below to new file

// Widget to show user photo name and button for remove
class UserMemberRow extends StatelessWidget {
  const UserMemberRow({
    super.key,
    required this.name,
    required this.photo,
    required this.index,
    required this.onTapDelete,
  });

  final String name;
  final String? photo;
  final int index;
  final Function(int) onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        width: widthDevice - 84, //(20+10+8+4)*2 = 84 padding
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        )),
        child: Row(
          children: [
            Text(
              "${index + 1}.-",
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            UserPhotoWidget(
              photo: photo,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Spacer(),
            IconButton(
              onPressed: () {
                onTapDelete(index);
              },
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
