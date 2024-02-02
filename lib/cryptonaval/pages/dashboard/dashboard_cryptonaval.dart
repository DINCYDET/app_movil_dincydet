import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/dashboard/custom_scaffold.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/dashboard/widgets/squared_tile.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/cryptonaval/widgets/userphoto.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:easy_software/charts/donut_chart.dart';
import 'package:easy_software/charts/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class DashboardCryptoPage extends StatefulWidget {
  const DashboardCryptoPage({super.key});

  @override
  State<DashboardCryptoPage> createState() => _DashboardCryptoPageState();
}

class _DashboardCryptoPageState extends State<DashboardCryptoPage> {
  final client = Provider.of<CryptoMainProvider>(navigatorKey.currentContext!,
          listen: false)
      .client;
  Uri? avatar;
  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Panel CryptoNaval',
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                UserPhoto(
                  avatar: avatar,
                  client: client,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenid@',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      client.userID!.localpart!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: StreamBuilder(
                        stream: client.onSync.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }

                          final rooms = client.rooms;

                          return GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              SquaredTile(
                                title: 'Mensajería',
                                icon: CupertinoIcons.text_bubble_fill,
                                count: getMessagesRoomsCount,
                                route: '/messages',
                              ),
                              SquaredTile(
                                title: 'Tickets',
                                icon: CupertinoIcons.ticket_fill,
                                count: getTicketsRoomsCount,
                              ),
                              SquaredTile(
                                title: 'Proyectos',
                                icon: CupertinoIcons.chart_bar_square_fill,
                                count: getProjectsRoomsCount,
                              ),
                              SquaredTile(
                                title: 'Repositorio',
                                icon: CupertinoIcons.checkmark_square_fill,
                                count: getRepositoryRoomsCount,
                              ),
                              const SquaredTile(
                                title: 'Configuración',
                                icon: CupertinoIcons.settings,
                                route: '/settings',
                              ),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: LayoutBuilder(builder: (context, constrains) {
                      final height = constrains.maxHeight;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Efectivos: 45',
                                              style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: DonutChart(
                                                vertical: true,
                                                data: [
                                                  DonutChartElement(
                                                    'A bordo',
                                                    15.0,
                                                    const Color(0xFF1D154A),
                                                  ),
                                                  DonutChartElement(
                                                    'Ausentes',
                                                    30.0,
                                                    const Color(0xFFDA1E14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Ausentes: 30',
                                              style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: DonutChart(
                                                vertical: true,
                                                data: [
                                                  DonutChartElement(
                                                      'Falto',
                                                      5.0,
                                                      Colors.yellow.shade700),
                                                  DonutChartElement(
                                                    'Vacaciones',
                                                    4.0,
                                                    Colors.green.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Permiso',
                                                    7.0,
                                                    Colors.blue.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Guardia',
                                                    4.0,
                                                    Colors.red.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Hospital',
                                                    8.0,
                                                    Colors.purple.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Licencia',
                                                    2.0,
                                                    Colors.orange.shade700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: height,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Seleccionar Proyecto',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Tickets Totales',
                                              style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: DonutChart(
                                                vertical: true,
                                                data: [
                                                  DonutChartElement(
                                                      'Falta',
                                                      5.0,
                                                      Colors.yellow.shade700),
                                                  DonutChartElement(
                                                    'Tarea',
                                                    4.0,
                                                    Colors.green.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Seguridad',
                                                    7.0,
                                                    Colors.blue.shade700,
                                                  ),
                                                  DonutChartElement(
                                                    'Proyecto',
                                                    4.0,
                                                    Colors.red.shade700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadAvatar() async {
    avatar = await client.getAvatarUrl(client.userID!);
    setState(() {});
  }

  int get getMessagesRoomsCount {
    final rooms = client.rooms;
    int count = 0;
    for (var room in rooms) {
      if (room.name.startsWith('!')) {
        continue;
      }
      count += 1;
    }
    return count;
  }

  int get getTicketsRoomsCount {
    final rooms = client.rooms;
    int count = 0;
    for (var room in rooms) {
      if (room.name.startsWith('!TICKET-')) {
        count += 1;
      }
    }
    return count;
  }

  int get getProjectsRoomsCount {
    final rooms = client.rooms;
    int count = 0;
    for (var room in rooms) {
      if (room.name.startsWith('!PROJECT-')) {
        count += 1;
      }
    }
    return count;
  }

  int get getRepositoryRoomsCount {
    final rooms = client.rooms;
    int count = 0;
    for (var room in rooms) {
      if (room.name.startsWith('!REPOSITORY-')) {
        count += 1;
      }
    }
    return count;
  }
}
