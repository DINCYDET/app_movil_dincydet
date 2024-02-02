import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/stats/statsuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:provider/provider.dart';

class StatsUserPage extends StatelessWidget {
  const StatsUserPage({super.key});
  final TextStyle rowstyle = const TextStyle(
    fontSize: 14,
    color: Color(0xFF535E78),
  );
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  final TextStyle row2style = const TextStyle(
    fontSize: 12,
    color: Color(0xFF535E78),
  );
  final TextStyle header2Style = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Indicadores de desempeño',
      section: DrawerSection.stats,
      body: ChangeNotifierProvider(
        create: (context) => StatsUserProvider(),
        child: Consumer<StatsUserProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300, //TODO: More height if needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Lista de Tareas:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Buscar tarea',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  prefixIcon: Icon(Icons.search),
                                ),
                                controller: provider.searchController,
                                onChanged: provider.onChangedSearch,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: MC_darkblue,
                                width: 2,
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: List.generate(provider.tasks.length,
                                    (index) {
                                  var row = provider.tasks[index];
                                  return Visibility(
                                    visible: row['NAME']
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                            provider.searchText.toLowerCase()),
                                    child: SizedBox(
                                      height: 70,
                                      child: InkWell(
                                        onTap: () => provider.onTapTask(index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                provider.selectedIndex == index
                                                    ? const Color(0x400096C7)
                                                    : Colors.white,
                                            border: Border(
                                                left: BorderSide(
                                                  color: provider
                                                              .selectedIndex ==
                                                          index
                                                      ? const Color(0xFF0096C7)
                                                      : Colors.white,
                                                  width: 19,
                                                ),
                                                bottom: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey.shade300,
                                                )),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  row['NAME'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        provider.selectedIndex ==
                                                                index
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.info,
                                                color: parseValidation(
                                                    row['VALIDATED']),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible:
                              Provider.of<MainProvider>(context, listen: false)
                                  .isAdmin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: provider.onTapAdminMode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MC_darkblue,
                                ),
                                child: const Text('Ir a vista de admin'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  provider.selectedIndex == null
                      ? const Center(
                          child: Text('Seleccione una tarea'),
                        )
                      : Column(
                          children: [
                            Visibility(
                              visible:
                                  provider.selectedTask!['VALIDATED'] != true,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  InkWell(
                                    onTap: provider.onTapValidation,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: provider.selectedTask![
                                                    'VALIDATED'] ==
                                                null
                                            ? const Color(0xFFB3261E)
                                            : const Color(0xFFCA8D32),
                                      ),
                                      child: Text(
                                        provider.selectedTask!['VALIDATED'] ==
                                                null
                                            ? 'Solicitar Validación'
                                            : 'Validación Solicitada',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      label: 'Nombre de Tarea',
                                      controller: provider.nameController,
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      label: 'Inicio',
                                      controller: provider.startDateController,
                                      readOnly: true,
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                      label: 'Fin',
                                      controller: provider.endDateController,
                                      readOnly: true,
                                      minLines: 1,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Sub-Tareas',
                                    style: TextStyle(
                                      color: Color(0xFF005AC1),
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: const Color(0xFF005AC1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: provider.validated != true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...List.generate(provider.subTasks.length,
                                      (index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Sub-Tarea ${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: provider.validated ==
                                                      null
                                                  ? () => provider
                                                      .onTapRemoveSubTask(index)
                                                  : null,
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Color(0xFFB3261E),
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyTextField(
                                                controller:
                                                    provider.subTasks[index]
                                                        ['nameController'],
                                                label:
                                                    'Nombre de Sub-Tarea ${index + 1}',
                                                readOnly:
                                                    provider.validated != null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MyTextField(
                                                controller:
                                                    provider.subTasks[index]
                                                        ['startDateController'],
                                                label: 'Inicio',
                                                readOnly: true,
                                                onTap: provider.validated !=
                                                        null
                                                    ? null
                                                    : () => provider
                                                        .onTapStartDate(index),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: MyTextField(
                                                controller:
                                                    provider.subTasks[index]
                                                        ['endDateController'],
                                                label: 'Fin',
                                                readOnly: true,
                                                onTap: provider.validated !=
                                                        null
                                                    ? null
                                                    : () => provider
                                                        .onTapEndDate(index),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: provider.validated == null
                                              ? provider.onTapAddSubTask
                                              : null,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.add_circle_outline,
                                                color: Color(0xFF2B9D0F),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Añadir Subtarea',
                                                style: TextStyle(
                                                  color: Color(0xFF79747E),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: provider.selectedTask!['ADVANCE'] == 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: provider.onTapQueryCompletion,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: provider.completionColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                    ),
                                    label: Text(
                                      provider.completionLabel,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    icon: const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            provider.validated == true
                                ? SizedBox(
                                    height: 250,
                                    child: provider.subTasks.isEmpty
                                        ? const Center(
                                            child: Text(
                                                'No se han asignado subtareas'),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              width: max(widthDevice - 40, 470),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListView(
                                                      children: [
                                                        GanttChartView(
                                                          startDate: provider
                                                              .minStartDate,
                                                          maxDuration: provider
                                                              .maxDuration,
                                                          eventHeight: 75,
                                                          stickyAreaEventBuilder:
                                                              (context,
                                                                  eventIndex,
                                                                  event,
                                                                  eventColor) {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    eventColor,
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  event.displayName ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          events: List.generate(
                                                            provider.subTasks
                                                                .length,
                                                            (index) {
                                                              return GanttAbsoluteEvent(
                                                                startDate: provider
                                                                            .subTasks[
                                                                        index][
                                                                    'startDate'],
                                                                endDate: provider
                                                                            .subTasks[
                                                                        index]
                                                                    ['endDate'],
                                                                displayName:
                                                                    provider.subTasks[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                suggestedColor:
                                                                    Colors.blue
                                                                        .shade100,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: provider.validated == true,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '% Avance',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: PieChart(
                                                PieChartData(
                                                  sections: [
                                                    PieChartSectionData(
                                                      value: provider
                                                              .selectedTask?[
                                                                  'ADVANCE']
                                                              ?.toDouble() ??
                                                          0,
                                                      color: const Color(
                                                          0xFFDA781E),
                                                      title:
                                                          '${provider.selectedTask?['ADVANCE']?.toDouble()}%',
                                                      radius: 50,
                                                      titleStyle:
                                                          const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                      showTitle: true,
                                                    ),
                                                    PieChartSectionData(
                                                      value: (100 -
                                                              (provider
                                                                      .selectedTask?[
                                                                          'ADVANCE']
                                                                      ?.toDouble() ??
                                                                  0))
                                                          .toDouble(),
                                                      color: const Color(
                                                          0xFFC7C3CA),
                                                      radius: 50,
                                                      showTitle: false,
                                                    ),
                                                  ],
                                                ),
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
                                          const SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Subtareas\ncompletadas:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(provider.completedSubTasks
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Por\ncompletar:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(provider.nonCompletedSubTasks
                                              .toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Actualizar Avance',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Seleccionar Subtarea',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        isExpanded: true,
                                        value: provider.subTaskIndex,
                                        items: List.generate(
                                          provider.subTasks.length,
                                          (index) {
                                            return DropdownMenuItem(
                                              value: index,
                                              child: Text(provider
                                                  .subTasks[index]['name']),
                                            );
                                          },
                                        ),
                                        onChanged: provider.onChangedSubTask,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyTextField(
                                        label: 'Descripción Avance',
                                        controller:
                                            provider.descriptionController,
                                        minLines: 3,
                                        maxLines: 3,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Progreso:',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          //TODO: Cambiar por slider
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Slider(
                                                  max: 100.0,
                                                  activeColor:
                                                      const Color(0xFF6750A4),
                                                  label: provider.sliderValue
                                                      .toInt()
                                                      .toString(),
                                                  value: provider.sliderValue,
                                                  onChanged:
                                                      provider.onSliderChanges,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: InputDecorator(
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Valor',
                                                    isDense: true,
                                                  ),
                                                  child: Text(
                                                    '${provider.sliderValue.toInt()}%',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InputDecorator(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Adjuntos',
                                          isDense: true,
                                        ),
                                        child: SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: provider.fileName == null
                                              ? const Icon(
                                                  Icons.cloud_upload,
                                                  color: Color(0xFF000000),
                                                  size: 40,
                                                )
                                              : Center(
                                                  child:
                                                      Text(provider.fileName!),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton.icon(
                                            onPressed: provider.onTapAddFile,
                                            icon: const Icon(Icons.attach_file),
                                            label: const Text('Documento'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFF6251A2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFF101139),
                                            ),
                                            onPressed: provider.onTapCancel,
                                            child: const Text('Cancelar'),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: provider.onTapUpdate,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF101139),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 15,
                                              ),
                                            ),
                                            icon: const Icon(Icons.save),
                                            label: const Text('Actualizar'),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Color parseValidation(bool? value) {
    if (value == null) {
      return const Color(0xFFB3261E);
    } else if (value) {
      return const Color(0xFF2B9D0F);
    } else {
      return const Color(0xFFCA8D32);
    }
  }
}
