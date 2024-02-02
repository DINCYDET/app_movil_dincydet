import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/home/dashboard_provider.dart';
import 'package:app_movil_dincydet/src/utils/charts.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Dashboard',
      drawer: true,
      section: DrawerSection.dashboard,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ChangeNotifierProvider<DashboardProvider>(
          create: (context) => DashboardProvider(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // const Padding(
                //   padding: EdgeInsets.all(30),
                //   child: RealTimeMap(),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Tipo de Zafarrancho',
                              isDense: true,
                            ),
                            padding:
                                const EdgeInsets.all(5), //sin padding corta al label
                            isExpanded: true,
                            onChanged: provider.onChangeAlertType,
                            value: provider.alertType,
                            items: List.generate(alertTypes.length, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(alertTypes[index]),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        TextButton.icon(
                          onPressed: provider.onTapAlert,
                          icon: const Icon(Icons.phone),
                          label: const Text('Llamada colectiva'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10.0),
                            fixedSize: const Size(200, 40),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF101139),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        OutlinedButton.icon(
                          onPressed: provider.onTapCall,
                          icon: const Icon(Icons.phone),
                          label: const Text('Llamada personal'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(10.0),
                            fixedSize: const Size(200, 40),
                            foregroundColor: const Color(0xFF101139),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Resumen del Parte',
                    style: TextStyle(
                      color: MC_lightblue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      height: 550,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: provider.assistanceData.isNotEmpty
                                ? MyPieChart(
                                    label: 'INGRESO Y SALIDA DE DINCYDET',
                                    data: [
                                      {
                                        'domain': 'A bordo',
                                        'measure':
                                            provider.assistanceData["0"] ?? 0,
                                        'color': const Color(0xFF1D154A)
                                      },
                                      {
                                        'domain': 'Fuera del área',
                                        'measure': provider.suggestions.length -
                                            (provider.assistanceData["0"] ?? 0),
                                        'color': const Color(0xFFDA1E14)
                                      }
                                    ],
                                  )
                                : const Card(
                                    margin: EdgeInsets.all(10.0),
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.close_outlined,
                                            color: Colors.red,
                                            size: 96,
                                          ),
                                          Text(
                                            'No hay usuarios',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: provider.assistancePartTotal != 0 &&
                                    provider.assistancePartData.isNotEmpty
                                ? MyPieChart(
                                    label:
                                        'EFECTIVOS: ${provider.assistancePartTotal}\n\n',
                                    data: List.generate(
                                      personalTypes.length,
                                      (index) {
                                        return {
                                          'domain': personalTypes[index],
                                          'measure':
                                              provider.assistancePartData[
                                                      "$index"] ??
                                                  0,
                                          // Color from primary colors and index
                                          'color': Colors.primaries[
                                              index % Colors.primaries.length],
                                        };
                                      },
                                    ),
                                  )
                                : const Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(10.0),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 96,
                                          ),
                                          Text(
                                            'Todos presentes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MC_darkblue,
                          padding: const EdgeInsets.all(15.0),
                        ),
                        onPressed: provider.onTapToPersonal,
                        child: const Text(
                          'Parte General',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Resumen de Tickets Abiertos',
                    style: TextStyle(
                      color: MC_lightblue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 540,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 300,
                              child: provider.sChart
                                  ? MyPieChart(
                                      label: 'Tickets totales en el sistema',
                                      data: [
                                        {
                                          'domain': 'Seguridad',
                                          'measure': provider.tsummary['all']
                                              ["0"],
                                          'color': Colors.blue
                                        },
                                        {
                                          'domain': 'Proyecto',
                                          'measure': provider.tsummary['all']
                                              ["1"],
                                          'color': Colors.green
                                        },
                                        {
                                          'domain': 'Falta',
                                          'measure': provider.tsummary['all']
                                              ["2"],
                                          'color': Colors.redAccent
                                        },
                                        {
                                          'domain': 'Tarea',
                                          'measure': provider.tsummary['all']
                                              ["3"],
                                          'color': Colors.purple,
                                        }
                                      ],
                                    )
                                  : const Card(
                                      margin: EdgeInsets.all(10.0),
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close_outlined,
                                              color: Colors.red,
                                              size: 96,
                                            ),
                                            Text(
                                              'No hay Tickets emitidos pendientes',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 300,
                              child: provider.eChart
                                  ? MyPieChart(
                                      label: 'Mis Tickets emitidos',
                                      data: [
                                        {
                                          'domain': 'Seguridad',
                                          'measure':
                                              provider.tsummary['emitted']["0"],
                                          'color': Colors.blue
                                        },
                                        {
                                          'domain': 'Proyecto',
                                          'measure':
                                              provider.tsummary['emitted']["1"],
                                          'color': Colors.green
                                        },
                                        {
                                          'domain': 'Falta',
                                          'measure':
                                              provider.tsummary['emitted']["2"],
                                          'color': Colors.redAccent
                                        },
                                        {
                                          'domain': 'Tarea',
                                          'measure':
                                              provider.tsummary['emitted']["3"],
                                          'color': Colors.purple,
                                        }
                                      ],
                                    )
                                  : const Card(
                                      elevation: 10,
                                      margin: EdgeInsets.all(10.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 96,
                                            ),
                                            Text(
                                              'No hay tickets emitidos pendientes',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 300,
                              child: provider.rChart
                                  ? MyPieChart(
                                      label: 'Mis Tickets recibidos',
                                      data: [
                                        {
                                          'domain': 'Seguridad',
                                          'measure': provider
                                              .tsummary['received']["0"],
                                          'color': Colors.blue
                                        },
                                        {
                                          'domain': 'Proyecto',
                                          'measure': provider
                                              .tsummary['received']["1"],
                                          'color': Colors.green
                                        },
                                        {
                                          'domain': 'Falta',
                                          'measure': provider
                                              .tsummary['received']["2"],
                                          'color': Colors.redAccent
                                        },
                                        {
                                          'domain': 'Tarea',
                                          'measure': provider
                                              .tsummary['received']["3"],
                                          'color': Colors.purple,
                                        }
                                      ],
                                    )
                                  : const Card(
                                      elevation: 10,
                                      margin: EdgeInsets.all(10.0),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 96,
                                            ),
                                            Text(
                                              'No hay tickets recibidos pendientes',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
