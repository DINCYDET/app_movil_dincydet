// ignore_for_file: use_build_context_synchronously, constant_identifier_names

import 'package:app_movil_dincydet/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

enum Ttypes {
  Seguridad,
  Proyecto,
  Falta,
  Tarea,
}

class TicketViewAddon extends StatelessWidget {
  const TicketViewAddon({
    super.key,
    required this.ttype,
    required this.isin,
    required this.ticketid,
    required this.status,
    required this.token,
  });
  final Ttypes ttype;
  final bool isin;
  final int ticketid;
  final int status;
  final String token;
  @override
  Widget build(BuildContext context) {
    switch (ttype) {
      case Ttypes.Proyecto:
        {
          return ChangeNotifierProvider(
            create: (context) => ProjectTaskProvider(
              status: status,
              ticketid: ticketid,
              token: token,
            ),
            child: ProjectTaskAddon(
              isin: isin,
              token: token,
            ),
          );
        }

      default:
        return Provider(
          create: (context) => BasicProvider(
            status: status,
            ticketid: ticketid,
            token: token,
          ),
          child: BasicAddon(
            isin: isin,
            token: token,
          ),
        );
    }
  }
}

// Addon de Proyectos

class ProjectTaskProvider extends ChangeNotifier {
  int ticketid;
  int status;
  String token;
  ProjectTaskProvider(
      {required this.status, required this.ticketid, required this.token}) {
    updateInfo();
  }

  String label = 'Abierto';
  Color color = Colors.blue;
  bool active = false;

  final TextEditingController prjController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();
  int progress = 0;

  void analyze() {
    if (status == 1) {
      color = Colors.green;
      label = 'Cerrado';
      active = false;
    } else {
      active = true;
    }
  }

  void updateInfo() async {
    final Response<dynamic>? response = await getTicketInfo();
    if (response == null || response.data['message'] != null) {
      return;
    }
    final data = response.data;
    prjController.text = data['prj'];
    taskController.text = data['task'];
    subtaskController.text = data['subtask'];
    progress = data['progress'];
    analyze();
    notifyListeners();
  }

  Future<Response<dynamic>?> getTicketInfo() async {
    Response<dynamic>? response;
    try {
      response = await Dio().post(
        '${apiBase}tickets/get/byid/',
        data: {'ID': ticketid},
        options: Options(
          headers: {
            'x-access-tokens': token,
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      response = null;
      //print(e);
    }
    return response;
  }

  void closeTicket(String token, BuildContext context) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: 'Completando',
      barrierDismissible: false,
    );
    final Response<dynamic>? response = await setTicketStatus();
    Navigator.of(context).pop();
    if (response == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'No se pudo completar',
      );
      return;
    }
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Completado',
      barrierDismissible: false,
    );
    Navigator.of(context).pop(true);
  }

  Future<Response<dynamic>?> setTicketStatus() async {
    Response<dynamic>? response;
    try {
      response = await Dio().post(
        '${apiBase}tickets/close/byid/',
        data: {'ID': ticketid},
        options: Options(
          headers: {
            'x-access-tokens': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      //print(response.data);
    } catch (e) {
      response = null;
      //print(e);
    }
    return response;
  }

  Future<Response<dynamic>?> setProyStatus() async {
    Response<dynamic>? response;
    try {
      response = await Dio().post(
        '${apiBase}tickets/proy/set/',
        data: {'ID': ticketid, 'progress': progress},
        options: Options(
          headers: {
            'x-access-tokens': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      //print(response.data);
    } catch (e) {
      response = null;
      //print(e);
    }
    return response;
  }

  void updateProgress(BuildContext context) async {
    double newprogress = progress.toDouble();
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Progreso',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SleekCircularSlider(
              min: 0,
              max: 100,
              appearance:
                  CircularSliderAppearance(customColors: CustomSliderColors()),
              initialValue: progress.toDouble(),
              onChange: (value) {
                newprogress = value;
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: const Text('Actualizar'),
                onPressed: () async {
                  progress = newprogress.toInt();
                  final Response<dynamic>? response = await setProyStatus();
                  String text = 'Se actualizo correctamente';
                  if (response == null || response.data['message'] != null) {
                    text = 'Ocurrio un problema';
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(text)));
                },
              ),
            )
          ],
        );
      },
    );
    notifyListeners();
  }
}

class ProjectTaskAddon extends StatelessWidget {
  const ProjectTaskAddon({super.key, required this.isin, required this.token});
  final bool isin;
  final String token;
  @override
  Widget build(BuildContext context) {
    return isin
        ? Consumer<ProjectTaskProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Container(
                    color: provider.color,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      provider.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.prjController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Proyecto'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.taskController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Tarea'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.subtaskController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Subtarea'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${provider.progress}%',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Progresso(
                          progress: (provider.progress / 100).toDouble(),
                          backgroundColor: Colors.grey.shade200,
                          progressColor: Colors.blue,
                          progressStrokeCap: StrokeCap.round,
                          backgroundStrokeCap: StrokeCap.round,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: provider.active
                        ? () {
                            provider.updateProgress(context);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.white),
                    child: const Text('Editar progreso'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: provider.active
                        ? () {
                            provider.closeTicket(token, context);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.white),
                    child: const Text('Finalizar'),
                  ),
                ],
              );
            },
          )
        : Consumer<ProjectTaskProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Container(
                    color: provider.color,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      provider.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.prjController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Proyecto'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.taskController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Tarea'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.subtaskController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        label: Text('Subtarea'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${provider.progress}%',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Progresso(
                          progress: (provider.progress / 100).toDouble(),
                          backgroundColor: Colors.grey.shade200,
                          progressColor: Colors.blue,
                          progressStrokeCap: StrokeCap.round,
                          backgroundStrokeCap: StrokeCap.round,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Spacer(),
                ],
              );
            },
          );
  }
}

class BasicProvider {
  int ticketid;
  int status;
  String token;
  BasicProvider({
    required this.status,
    required this.ticketid,
    required this.token,
  }) {
    analyze();
  }

  String label = 'Abierto';
  Color color = Colors.blue;
  bool active = false;

  void analyze() {
    if (status == 1) {
      color = Colors.green;
      label = 'Cerrado';
      active = false;
    } else {
      active = true;
    }
  }

  void closeTicket(String token, BuildContext context) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: 'Completando',
      barrierDismissible: false,
    );
    final Response<dynamic>? response = await setTicketStatus();
    Navigator.of(context).pop();
    if (response == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'No se pudo completar',
      );
      return;
    }
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Completado',
      barrierDismissible: false,
    );
    Navigator.of(context).pop(true);
  }

  Future<Response<dynamic>?> setTicketStatus() async {
    Response<dynamic>? response;
    try {
      response = await Dio().post(
        '${apiBase}tickets/close/byid/',
        data: {'ID': ticketid},
        options: Options(
          headers: {
            'x-access-tokens': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      //print(response.data);
    } catch (e) {
      response = null;
      //print(e);
    }
    return response;
  }
}

class BasicAddon extends StatelessWidget {
  const BasicAddon({super.key, required this.isin, required this.token});
  final bool isin;
  final String token;
  @override
  Widget build(BuildContext context) {
    return isin
        ? Consumer<BasicProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Container(
                    color: provider.color,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      provider.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: provider.active
                        ? () {
                            provider.closeTicket(token, context);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.white),
                    child: const Text('Finalizar'),
                  ),
                ],
              );
            },
          )
        : Consumer<BasicProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  const Spacer(),
                  Container(
                    color: provider.color,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      provider.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
  }
}
