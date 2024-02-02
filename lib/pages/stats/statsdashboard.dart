import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_charts.dart';
import 'package:app_movil_dincydet/pages/projects/tasksbottom.dart';
import 'package:app_movil_dincydet/pages/stats/stats_charts.dart';
import 'package:app_movil_dincydet/pages/stats/stats_dash_tables.dart';
import 'package:app_movil_dincydet/providers/stats/statsdashboard_provider.dart';
import 'package:app_movil_dincydet/src/utils/charts.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:app_movil_dincydet/src/utils/user_photo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsDashboardPage extends StatelessWidget {
  const StatsDashboardPage({super.key});

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
        create: (context) => StatsDashboardProvider(),
        child: Consumer<StatsDashboardProvider>(
            builder: (context, provider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Lista de participantes:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Buscador',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                  isDense: true,
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
                                children: List.generate(provider.users.length,
                                    (index) {
                                  var row = provider.users[index];
                                  return Visibility(
                                    visible: row['FULLNAME']
                                        .toLowerCase()
                                        .contains(
                                            provider.searchText.toLowerCase()),
                                    child: SizedBox(
                                      height: 70,
                                      child: InkWell(
                                        onTap: () {
                                          provider.onTapUser(index);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                provider.selectedIndex == index
                                                    ? const Color(0xFF0096C7)
                                                    : Colors.transparent,
                                            border: Border(
                                                left: BorderSide(
                                                  color: provider
                                                              .selectedIndex ==
                                                          index
                                                      ? const Color(0xFF073264)
                                                      : Colors.white,
                                                  width: 8,
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
                                              SizedBox(
                                                width: 60,
                                                child: UserPhotoWidget(
                                                  photo: row['PHOTOURL'],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  row['FULLNAME'],
                                                  style: TextStyle(
                                                    color:
                                                        provider.selectedIndex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: provider.onTapToUserMode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MC_darkblue,
                              ),
                              child: const Text('Ir a vista de usuario'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  provider.selectedIndex == null
                      ? const Center(
                          child: Text('Seleccione un usuario'),
                        )
                      : DefaultTabController(
                          initialIndex: 1,
                          length: 3,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: provider.onTapNewTask,
                                    icon: const Icon(Icons.add),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF101139),
                                    ),
                                    label: const Text('Tarea'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                // width: max(widthDevice - 40, 550),
                                child: TabBar(
                                  labelPadding: EdgeInsets.zero,
                                  indicatorColor: Colors.black,
                                  tabs: [
                                    Tab(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 16,
                                            color: Color(0xFFCA8D32),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'Por Validar',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFCA8D32),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 16,
                                            color: Color(0xFF2B9D0F),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'Validadas',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF2B9D0F),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 16,
                                            color: Color(0xFF79747E),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'Finalizadas',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF79747E),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 300,
                                child: TabBarView(children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: max(widthDevice - 40, 600),
                                      child: StatsDashboardToValidateTable(
                                        data: provider.toValidateTasks,
                                        onRefresh: provider.getUserTasks,
                                        onTapDetails:
                                            provider.onTapToValidateDetails,
                                        onTapDelete:
                                            provider.onTapToValidateDelete,
                                        onTapEdit: provider.onTapToValidateEdit,
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: max(widthDevice - 40, 600),
                                      child: StatsDashboardValidatedTable(
                                        data: provider.validatedTasks,
                                        onRefresh: provider.getUserTasks,
                                        onTapDetails:
                                            provider.onTapValidatedDetails,
                                        onTapDelete:
                                            provider.onTapValidatedDelete,
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: max(widthDevice - 40, 600),
                                      child: StatsDashboardCompletedTable(
                                        data: provider.completedTasks,
                                        onRefresh: provider.getUserTasks,
                                        onTapDetails:
                                            provider.onTapCompletedDetails,
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tickets abiertos: ${provider.ticketsCount}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: PieChart(
                                              PieChartData(
                                                sections: List.generate(
                                                  4,
                                                  (index) {
                                                    final count = provider
                                                        .ticketCountData[index];
                                                    return PieChartSectionData(
                                                      color: Colors.accents[
                                                          index %
                                                              Colors.accents
                                                                  .length],
                                                      radius: 30,
                                                      showTitle: true,
                                                      title: count.toString(),
                                                      titleStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      value: count.toDouble(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: List.generate(
                                                4,
                                                (index) {
                                                  final count = provider
                                                      .ticketCountData[index];
                                                  return LabelIndicator(
                                                    color: Colors.accents[
                                                        index %
                                                            Colors.accents
                                                                .length],
                                                    label: provider
                                                        .ticketLabels[index],
                                                    value: count,
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tareas Retrasadas (${provider.overTimeTasks.length})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF535E78),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            child: Text(
                                              'Nº',
                                              style: header2Style,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Nombre',
                                              style: header2Style,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Fecha',
                                              style: header2Style,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Tiempo',
                                              style: header2Style,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView(
                                        children: List.generate(
                                            provider.overTimeTasks.length,
                                            (index) {
                                          final item =
                                              provider.overTimeTasks[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 5.0,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: row2style,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    item['NAME'],
                                                    style: row2style,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    isoToLocalDate(
                                                        item['ENDDATE']),
                                                    style: row2style,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${item['DAYS']} días',
                                                    style: row2style.copyWith(
                                                      color: const Color(
                                                          0xFFBB271A),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 350,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tendencia actualización avances',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField<int>(
                                        value: provider.selectedPlotTask,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                          labelText: 'Selección Tarea',
                                        ),
                                        items: List.generate(
                                            provider.tasks.length, (index) {
                                          final item = provider.tasks[index];
                                          return DropdownMenuItem<int>(
                                            value: index,
                                            child: Text(item['NAME']),
                                          );
                                        }),
                                        onChanged: provider.onChangePlotTask,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: LineChart(
                                            LineChartData(
                                              gridData: FlGridData(
                                                show: false,
                                              ),
                                              minY: 0,
                                              maxY: 100,
                                              titlesData: FlTitlesData(
                                                topTitles: AxisTitles(),
                                                rightTitles: AxisTitles(),
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 40,
                                                    interval: 25,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      return Text(
                                                        '${value.toInt()} %',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFF615E83),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    interval: 1,
                                                    showTitles: true,
                                                    reservedSize: 60,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      if (provider.plotSubTasks
                                                          .isEmpty) {
                                                        return const Text('');
                                                      }

                                                      return Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          child: Text(
                                                            // item['NAME'] ??
                                                            //     '-',
                                                            'SubT. ${value.toInt() + 1}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xFF615E83),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  color: Colors.red.shade400,
                                                  spots: List.generate(
                                                    provider
                                                        .plotSubTasks.length,
                                                    (index) {
                                                      return FlSpot(
                                                        index.toDouble(),
                                                        provider.plotSubTasks[
                                                            index]['CURRENT'],
                                                      );
                                                    },
                                                  ),
                                                ),
                                                LineChartBarData(
                                                  color:
                                                      const Color(0xFF073264),
                                                  spots: List.generate(
                                                    provider
                                                        .plotSubTasks.length,
                                                    (index) {
                                                      return FlSpot(
                                                        index.toDouble(),
                                                        provider.plotSubTasks[
                                                            index]['LAST'],
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
                                height: 300,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Proyectos asignados: ${provider.projectsCount}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: ListView(
                                          children: List.generate(
                                              provider.projects.length,
                                              (index) {
                                            final item =
                                                provider.projects[index];
                                            return StatsLabelProgressChart(
                                              name: item['PRJNAME'] ??
                                                  'Proyecto Sin Nombre',
                                              value: item['PRJADVANCE'] ?? 0,
                                              index: index,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class UserStatsWidget extends StatelessWidget {
  const UserStatsWidget({
    super.key,
    required this.name,
    required this.photo,
    required this.taskdata,
  });
  final String name;
  final String photo;
  final Map<String, dynamic> taskdata;

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    double adv = 0;
    if ((taskdata['tasks'] as List<dynamic>).isEmpty) {
      adv = 100;
    } else {
      int counter = 0;
      for (var task in taskdata['tasks']) {
        adv = adv + task['adv'];
        counter++;
      }
      adv = adv / counter;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tareas de $name',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BottomTaskList(
                  data: taskdata,
                  allowEdit: true,
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Desempeño trimestral',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GisDonutChart(
                        data: [
                          {
                            'domain': 'Completo',
                            'measure': adv,
                            'color': Colors.green
                          },
                          {
                            'domain': 'Permiso2',
                            'measure': 100 - adv,
                            'color': Colors.red
                          },
                        ],
                      ),
                    ),
                    const Text(
                      '% de tareas completadas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GisDonutChart(
                        data: [
                          {
                            'domain': 'Permiso',
                            'measure': rng.nextDouble() * 100,
                            'color': Colors.blue
                          },
                          {
                            'domain': 'Permiso2',
                            'measure': rng.nextDouble() * 100,
                            'color': Colors.red
                          },
                        ],
                      ),
                    ),
                    const Text(
                      '% de proyectos completados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
