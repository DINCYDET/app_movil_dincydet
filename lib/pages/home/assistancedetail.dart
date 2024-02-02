import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/api/urls.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/src/utils/charts.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssistancePage extends StatelessWidget {
  const AssistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssistanceProvider(),
      child: Consumer<AssistanceProvider>(builder: (context, provider, child) {
        return MyScaffold(
          title: 'Parte general',
          section: DrawerSection.other,
          drawer: false,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 780,
                  child: Row(
                    children: [
                      Expanded(
                        child: MyPieChart(
                          label: 'Efectivos:',
                          num: provider.present + provider.missing,
                          data: [
                            {
                              'domain': 'Presentes',
                              'measure': provider.present,
                              'color': Colors.black87
                            },
                            const {
                              'domain': 'Guardia',
                              'measure': 0,
                              'color': Colors.purple,
                            },
                            const {
                              'domain': 'Trabajando',
                              'measure': 0,
                              'color': Colors.blueGrey,
                            },
                            {
                              'domain': 'Vacaciones',
                              'measure': provider.vacations,
                              'color': Colors.orange
                            },
                            {
                              'domain': 'Permiso',
                              'measure': provider.permiss,
                              'color': Colors.blue
                            },
                            const {
                              'domain': 'Comision',
                              'measure': 0,
                              'color': Color.fromARGB(255, 82, 255, 169),
                            },
                            const {
                              'domain': 'Destacados del',
                              'measure': 0,
                              'color': Color.fromARGB(255, 161, 150, 29),
                            },
                            const {
                              'domain': 'Destacados al',
                              'measure': 0,
                              'color': Color.fromARGB(255, 177, 82, 255),
                            },
                            {
                              'domain': 'Hospital',
                              'measure': provider.hospital,
                              'color': Colors.green
                            },
                            const {
                              'domain': 'Descanso medico',
                              'measure': 0,
                              'color': Colors.redAccent,
                            },
                            {
                              'domain': 'Falto',
                              'measure': provider.other,
                              'color': Colors.yellow
                            },
                          ],
                        ),
                      ),
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.all(15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DefaultTabController(
                              length: 11,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const TabBar(
                                      isScrollable: true,
                                      labelColor: Colors.blue,
                                      indicatorColor: Colors.blue,
                                      indicator: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      tabs: [
                                        Tab(
                                          text: 'Presentes',
                                        ),
                                        Tab(
                                          text: 'Guardia',
                                        ),
                                        Tab(
                                          text: 'Trabajando',
                                        ),
                                        Tab(
                                          text: 'Vacaciones',
                                        ),
                                        Tab(
                                          text: 'Permiso',
                                        ),
                                        Tab(
                                          text: 'Comisión',
                                        ),
                                        Tab(
                                          text: 'Destacados del',
                                        ),
                                        Tab(
                                          text: 'Destacados al',
                                        ),
                                        Tab(
                                          text: 'Hospt. Cemena',
                                        ),
                                        Tab(
                                          text: 'Descanso Medico',
                                        ),
                                        Tab(
                                          text: 'Falto',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(children: [
                                      UserListWidget(
                                        data: provider.datalist['present'],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      UserListWidget(
                                        data: provider.datalist['vacations'],
                                      ),
                                      UserListWidget(
                                        data: provider.datalist['permission'],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      UserListWidget(
                                        data: provider.datalist['hospital'],
                                      ),
                                      const UserListWidget(
                                        data: [],
                                      ),
                                      UserListWidget(
                                        data: provider.datalist['other'],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement report
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MC_darkblue,
                        ),
                        child: const Text(
                          'Generar reporte',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AssistanceProvider extends ChangeNotifier {
  AssistanceProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateData();
      getAssistanceWithNames();
    });
  }

  Map<String, dynamic> datalist = {
    'present': [],
    'hospital': [],
    'vacations': [],
    'permission': [],
    'other': [],
  };

  // Provider for pie charts
  int present = 0;
  int missing = 0;
  int hospital = 0;
  int permiss = 0;
  int vacations = 0;
  int other = 0;
  bool chart1 = false;
  bool chart2 = false;

  void updateData() async {
    final response = await getUsersAssistance();
    final rdata = response.data;
    present = rdata['PRESENT'];
    missing = rdata['MISSING'];
    hospital = rdata['HOSPITAL'];
    permiss = rdata['PERMS'];
    vacations = rdata['VACATIONS'];
    other = rdata['OTHER'];
    chart1 = (present + missing) > 0;
    chart2 = (missing) > 0;
    notifyListeners();
  }

  Future getUsersAssistance() async {
    Response<dynamic>? response;
    try {
      response = await Dio().get('${apiBase}users/get/assistance/all/');
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future getAssistanceDetail() async {
    Response<dynamic>? response;
    try {
      response = await Dio().get(
        '${apiBase}assistance/detailed/',
        options: Options(
          headers: {
            'x-access-tokens': Provider.of<MainProvider>(
                    navigatorKey.currentContext!,
                    listen: false)
                .TOKEN,
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print(e);
    }
    return response;
  }

  void getAssistanceWithNames() async {
    Map<String, dynamic>? data = await apiAssistanceDetailed();
    if (data == null) {
      return;
    }
    datalist = data;
    notifyListeners();
  }
}

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key, required this.data});
  final List<dynamic> data;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(data.length, (index) {
        final row = data[index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          )),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImageBuilder(
                url: row['photo'],
                builder: (image) {
                  return CircleAvatar(
                    foregroundImage: FileImage(image),
                  );
                },
                errorWidget: const CircleAvatar(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                row['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
