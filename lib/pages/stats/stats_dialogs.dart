import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:intl/intl.dart';

class StatsNewDialog extends StatefulWidget {
  const StatsNewDialog({
    super.key,
    this.data,
  });

  final Map<String, dynamic>? data;
  @override
  State<StatsNewDialog> createState() => _StatsNewDialogState();
}

class _StatsNewDialogState extends State<StatsNewDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.data != null) {
      nameController.text = widget.data!['NAME'];
      startDateController.text = isoToLocalDate(widget.data!['STARTDATE']);
      endDateController.text = isoToLocalDate(widget.data!['ENDDATE']);
      startDate = isoParseDateTime(widget.data!['STARTDATE']);
      endDate = isoParseDateTime(widget.data!['ENDDATE']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SimpleDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.all(10.0),
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          color: const Color(0xFF073264),
          alignment: Alignment.center,
          child: const Text(
            'Añadir tarea',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre de Tarea',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nombre de Tarea es requerido';
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    hintText: 'Fecha Inicio',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onTap: onTapStartDate,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fecha Inicio es requerida';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: endDateController,
                  decoration: const InputDecoration(
                    hintText: 'Fecha Fin',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onTap: onTapEndDate,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fecha Fin es requerida';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onTapSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF101139),
                ),
                child: const Text('Aceptar'),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: onTapCancel,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF101139),
                ),
                child: const Text('Cancelar'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: endDate ?? DateTime(2500),
    );
    if (picked != null) {
      startDate = picked;
      startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {});
    }
  }

  void onTapEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2500),
    );
    if (picked != null) {
      endDate = picked;
      endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {});
    }
  }

  void onTapSave() {
    final Map<String, dynamic> dataMap = {
      'STARTDATE': startDate!.toIso8601String(),
      'ENDDATE': endDate!.toIso8601String(),
      'NAME': nameController.text,
    };
    Navigator.pop(context, dataMap);
  }
}

class StatsToValidateDetailsDialog extends StatefulWidget {
  const StatsToValidateDetailsDialog({
    super.key,
    required this.selectedTask,
    required this.subTasks,
  });

  final Map<String, dynamic> selectedTask;
  final List<Map<String, dynamic>> subTasks;

  @override
  State<StatsToValidateDetailsDialog> createState() =>
      _StatsToValidateDetailsDialogState();
}

class _StatsToValidateDetailsDialogState
    extends State<StatsToValidateDetailsDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(10.0),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView(
            children: [
              Visibility(
                visible: widget.selectedTask['VALIDATED'] == false,
                child: Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: onTapValidation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF2B9D0F),
                        ),
                        child: const Text(
                          'VALIDAR',
                          style: TextStyle(
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      label: 'Nombre de Tarea',
                      controller: widget.selectedTask['nameController'],
                      readOnly: true,
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
                    child: MyTextField(
                      label: 'Inicio',
                      controller: widget.selectedTask['startDateController'],
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
                      controller: widget.selectedTask['endDateController'],
                      readOnly: true,
                      minLines: 1,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
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
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    widget.selectedTask['SUBTASKS'].length,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              // IconButton(
                              //   onPressed: provider.validated == null
                              //       ? () => provider.onTapRemoveSubTask(index)
                              //       : null,
                              //   icon: Icon(
                              //     Icons.remove_circle,
                              //     color: Color(0xFFB3261E),
                              //     size: 16,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: MyTextField(
                                  controller: widget.subTasks[index]
                                      ['nameController'],
                                  label: 'Nombre de Sub-Tarea ${index + 1}',
                                  readOnly: true,
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
                                  controller: widget.subTasks[index]
                                      ['startDateController'],
                                  label: 'Inicio',
                                  readOnly: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: MyTextField(
                                  controller: widget.subTasks[index]
                                      ['endDateController'],
                                  label: 'Fin',
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onTapValidation() {
    Navigator.of(context).pop(true);
  }
}

class StatsValidatedDetailDialog extends StatefulWidget {
  const StatsValidatedDetailDialog({
    super.key,
    required this.minStartDate,
    required this.maxDuration,
    required this.subTasks,
    required this.reports,
    required this.selectedTask,
    required this.completedSubTasks,
    required this.nonCompletedSubTasks,
  });

  final DateTime minStartDate;
  final Duration maxDuration;
  final List<Map<String, dynamic>> subTasks;
  final List<Map<String, dynamic>> reports;
  final Map<String, dynamic> selectedTask;
  final int completedSubTasks;
  final int nonCompletedSubTasks;

  @override
  State<StatsValidatedDetailDialog> createState() =>
      _StatsValidatedDetailDialogState();
}

class _StatsValidatedDetailDialogState
    extends State<StatsValidatedDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 250,
                  child: widget.subTasks.isEmpty
                      ? const Center(
                          child: Text('No hay sub-tareas'),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: max(widthDevice * 0.8 - 40, 400),
                            child: ListView(
                              children: [
                                Visibility(
                                  visible: widget.selectedTask[
                                          'COMPLETIONVALIDATED'] ==
                                      false,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0x822B9D0F),
                                            foregroundColor: Colors.black,
                                          ),
                                          icon:
                                              const Icon(Icons.check_outlined),
                                          onPressed: onPressValidateCompletion,
                                          label: const Text(
                                            'Validar Finalización',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: max(widthDevice * 0.8 - 20, 400),
                                  child: GanttChartView(
                                    startDate: widget.minStartDate,
                                    maxDuration: widget.maxDuration,
                                    events: List.generate(
                                      widget.subTasks.length,
                                      (index) {
                                        return GanttAbsoluteEvent(
                                          startDate: widget.subTasks[index]
                                              ['startDate'],
                                          endDate: widget.subTasks[index]
                                              ['endDate'],
                                          displayName: widget.subTasks[index]
                                              ['name'],
                                          suggestedColor: Colors.blue.shade100,
                                        );
                                      },
                                    ),
                                    eventHeight: 60,
                                    stickyAreaEventBuilder: (context,
                                        eventIndex, event, eventColor) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                          vertical: 8.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: eventColor,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          event.displayName ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: widget.selectedTask['ADVANCE']
                                                ?.toDouble() ??
                                            0,
                                        color: const Color(0xFFDA781E),
                                        title:
                                            '${widget.selectedTask['ADVANCE']?.toDouble()}%',
                                        radius: 50,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        showTitle: true,
                                      ),
                                      PieChartSectionData(
                                        value: (100 -
                                                (widget.selectedTask['ADVANCE']
                                                        ?.toDouble() ??
                                                    0))
                                            .toDouble(),
                                        color: const Color(0xFFC7C3CA),
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
                            Text(widget.completedSubTasks.toString()),
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
                            Text(widget.nonCompletedSubTasks.toString()),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Historial Avance',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.reports.isEmpty
                            ? const Center(
                                child: Text('No hay reportes'),
                              )
                            : Column(
                                children: List.generate(widget.reports.length,
                                    (index) {
                                  final report = widget.reports[index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Icon(Icons.play_arrow),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              report['SUBTASKNAME'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'al ${report['PROGRESS']}%',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0096C7),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '(${isoToLocalDateTime(report['CREATEDAT'])})',
                                            style: const TextStyle(
                                              fontSize: 12,
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
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  child: InputDecorator(
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Descripción Avance',
                                                    ),
                                                    child: ListView(
                                                      children: [
                                                        Text(
                                                          report['DESCRIPTION'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                InputDecorator(
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Adjuntos',
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: InkWell(
                                                      onTap: () =>
                                                          onTapDownloadFile(
                                                              index),
                                                      child: Center(
                                                        child: Text(
                                                          getFileName(
                                                              report['FILE']),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF0096C7),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String getFileName(String? url) {
    if (url == null || url.isEmpty) return 'Sin archivo adjunto';
    return url.split('/').last;
  }

  void onTapDownloadFile(int index) {
    // TODO: Implement onTapDownloadFile
  }

  void onPressValidateCompletion() {
    Navigator.of(context).pop(true);
  }
}
