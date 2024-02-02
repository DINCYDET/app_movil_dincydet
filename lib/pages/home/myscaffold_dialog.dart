import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/previews/qr_assistance.dart';
import 'package:flutter/material.dart';

class AssistanceDialog extends StatefulWidget {
  const AssistanceDialog({super.key});

  @override
  State<AssistanceDialog> createState() => _AssistanceDialogState();
}

class _AssistanceDialogState extends State<AssistanceDialog> {
  void getAssistanceUser() async {
    final data = await apiGetAssistanceStatus();
    if (data == null) return;
    // print(data);
    myStatusAssistance = data['ISPRESENT'];
    setState(() {});
  }

  void setAssistanceUser() async {
    final data = await apiSetAssistanceStatus();
    if (data == null) return;
    // print(data);
    if (data['sucess'] == true) {
      getAssistanceUser();
    } else {}
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAssistanceUser();
    });
  }

  bool myStatusAssistance = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Align(
        alignment: Alignment.center,
        child: Text(
          'Asistencia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF073264),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: [
        Row(
          children: [
            const Text(
              'Estado de asistencia: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              ' ${myStatusAssistance ? 'Presente' : 'Ausente'}',
              style: TextStyle(
                color: myStatusAssistance ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  final qrReading =
                      await Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const QRAssistance();
                    },
                  ));
                  if (qrReading == null) {
                    return;
                  }

                  final confirm = await showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) {
                      return SimpleDialog(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '¿Está seguro que deseas\n marcar tu ${myStatusAssistance ? 'Salida' : 'Entrada'}?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: myStatusAssistance
                                    ? const Color(0xFFB3261E)
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: myStatusAssistance
                                        ? const Color(0xFFB3261E)
                                        : Colors.green,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Si')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade200,
                                    foregroundColor: const Color(0xFF073264),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No')),
                            ],
                          )
                        ],
                      );
                    },
                  );
                  if (confirm == null || confirm == false) return;

                  setAssistanceUser();
                },
                child:
                    Text('Marcar ${myStatusAssistance ? 'Salida' : 'Entrada'}'))
          ],
        ),
      ],
    );
  }
}
