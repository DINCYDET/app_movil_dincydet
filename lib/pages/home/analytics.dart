import 'package:app_movil_dincydet/api/urls.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:app_movil_dincydet/src/utils/tiles.dart';
import 'package:app_movil_dincydet/src/utils/userinfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: ChangeNotifierProvider<AnalyticsProvider>(
        create: (context) => AnalyticsProvider(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analítica',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Consumer<AnalyticsProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    AnalyticsCard(
                      increment: true,
                      label: "Tickets pendientes",
                      percent: 10,
                      value: "${provider.ntickets}",
                      icon: Icons.confirmation_num,
                    ),
                    AnalyticsCard(
                      increment: true,
                      label: "N° Proyectos asignados",
                      percent: 2.1,
                      value: "${provider.nprojs}",
                      icon: Icons.share_outlined,
                    ),
                    AnalyticsCard(
                      increment: false,
                      label: "Cumpleaños del mes",
                      percent: 1.8,
                      value: "${provider.nbirth}",
                      icon: Icons.cake,
                    ),
                    AnalyticsCard(
                      increment: true,
                      label: "Dias sin accidentes",
                      percent: 0,
                      value: "${provider.ndays}",
                      icon: Icons.calendar_month,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            /*
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TicketsVertWidget(),
                ),
                Expanded(
                  child: TicketsPendientes(
                    args: args,
                  ),
                ),
              ],
            ),
            */
          ],
        ),
      ),
    );
  }
}

class AnalyticsProvider extends ChangeNotifier {
  //TODO: get token from provider
  AnalyticsProvider() {
    initProvider();
  }
  int ntickets = 0;
  int nprojs = 0;
  int nbirth = 0;
  int ndays = 0;
  Future<Response<dynamic>?> getAnalytics(String token) async {
    Response<dynamic>? response;
    try {
      response = await Dio().get(
        '${apiBase}analytics/getall/',
        options: Options(
          headers: {
            'x-access-tokens': token,
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print(e);
    }
    return response;
  }

  void initProvider() async {
    const token = '';
    // TODO: Correct this
    Response<dynamic>? response = await getAnalytics(token);
    if (response == null) {
      print('Respuesta nula');
      return;
    }
    ntickets = response.data['ntickets'];
    nprojs = response.data['nprojs'];
    nbirth = response.data['nbirth'];
    ndays = response.data['ndays'];
    notifyListeners();
  }
}

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.increment,
    required this.label,
    required this.percent,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final double percent;
  final bool increment;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: MC_lightblue),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 192, 216, 253),
                      border:
                          Border.all(width: 1.0, color: Colors.blue.shade300),
                    ),
                    child: Icon(
                      icon,
                      color: MC_lightblueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              // TODO: Show details
              /*
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: Text(
                  'Expandir >',
                  style: TextStyle(color: MC_lightblueAccent),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}

class TicketsPendientes extends StatelessWidget {
  const TicketsPendientes({super.key, required this.args});

  final UserArguments args;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tickets Pendientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                TicketTile(
                  name: 'Mitcheel Williamson',
                  ttype: 'Salud',
                  shortname: 'MW',
                  args: args,
                ),
                TicketTile(
                  name: 'Sam Conner',
                  ttype: 'Emergencia',
                  shortname: 'SC',
                  args: args,
                ),
                TicketTile(
                  name: 'Christina Castro',
                  ttype: 'Salud',
                  shortname: 'CC',
                  args: args,
                ),
                TicketTile(
                  name: 'Harrlett Clark',
                  ttype: 'Otro',
                  shortname: 'HC',
                  args: args,
                ),
              ],
            ),
            const Divider(
              height: 1.0,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Expandir >'),
            )
          ],
        ),
      ),
    );
  }
}
