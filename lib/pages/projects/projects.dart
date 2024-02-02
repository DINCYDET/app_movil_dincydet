import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/projects/projects_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

class Proyectos extends StatelessWidget {
  const Proyectos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectsProvider(),
      child: Consumer<ProjectsProvider>(builder: (context, provider, child) {
        return MyScaffold(
          title: 'Proyectos',
          section: DrawerSection.projects,
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: max(1020, widthDevice -40),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.topCenter,
              child: const ProjectsTable(),
            ),
          ),
          fab: Provider.of<MainProvider>(context, listen: false).isAdmin
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF081929),
                  onPressed: provider.onTapNewProject,
                  label: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Crear proyecto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              : null,
        );
      }),
    );
  }
}

class ProjectsTableHeader extends StatelessWidget {
  const ProjectsTableHeader(
      {super.key, required this.spaces, required this.dx, required this.maxW});
  final TextStyle headerstyle = const TextStyle(
      fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
  final List<int> spaces;
  final int dx;
  final double maxW;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(dx * 0.5 * maxW / 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: dx / 2 * maxW / 100,
            ),
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  'N°',
                  style: headerstyle,
                ),
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[1] * maxW / 100,
              child: Text(
                'Nombre del proyecto',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[2] * maxW / 100,
              child: Text(
                'Jefe de proyecto',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[3] * maxW / 100,
              child: Text(
                '% Avanzado',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[4] * maxW / 100,
              child: Text(
                'N° Tickets',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[5] * maxW / 100,
              child: Text(
                'Estado',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[6] * maxW / 100,
              child: Text(
                'Fecha de cierre',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[7] * maxW / 100,
            ),
            SizedBox(
              width: dx / 2 * maxW / 100,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsTableRow extends StatelessWidget {
  const ProjectsTableRow({
    super.key,
    required this.data,
    required this.spaces,
    required this.dx,
    required this.index,
    required this.maxW,
  });
  final TextStyle rowstyle = const TextStyle(fontSize: 16, color: Colors.blue);
  final Map<String, dynamic> data;

  final List<int> spaces;
  final int dx;
  final double maxW;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(dx * 0.5 * maxW / 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: dx / 2 * maxW / 100,
            ),
            SizedBox(
              width: 40,
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: 50,
              child: Consumer<ProjectsProvider>(
                builder: (context, provider, child) {
                  return IconButton(
                    icon: const Icon(
                      Icons.more_vert_outlined,
                      color: MC_lightblue,
                    ),
                    onPressed: () => provider.onTapTasks(index, context),
                  );
                },
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[1] * maxW / 100,
              child: Text(
                data['NAME'],
                style: rowstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[2] * maxW / 100,
              child: Text(
                data['LEADNAME'],
                style: rowstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[3] * maxW / 100,
              child: Center(
                child: Progresso(
                  progress:
                      (data['ADVANCE'] * 1.0) / 100, //data['progress'] / 100,
                  progressStrokeCap: StrokeCap.round,
                  backgroundStrokeCap: StrokeCap.round,
                  progressStrokeWidth: 15.0,
                  backgroundStrokeWidth: 15.0,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[4] * maxW / 100,
              child: Center(
                child: Text(
                  data['TICKETS'].toString(),
                  style: rowstyle,
                ),
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[5] * maxW / 100,
              child: Row(
                children: [
                  data['STATUS'] == 1
                      ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : data['STATUS'] == 2
                          ? const Icon(
                              Icons.info,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.info,
                              color: Colors.yellow,
                            ),
                  const SizedBox(
                    width: 3,
                  ),
                  data['STATUS'] == 1
                      ? Text(
                          'Abierto',
                          style: rowstyle,
                        )
                      : data['STATUS'] == 2
                          ? Text(
                              'Cerrado',
                              style: rowstyle,
                            )
                          : Text(
                              'Archivado',
                              style: rowstyle,
                            ),
                ],
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[6] * maxW / 100,
              child: Text(
                data['ENDDATE'],
                style: rowstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[7] * maxW / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3.0),
                      child: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      //TODO: Review this part of code
                      Provider.of<ProjectsProvider>(context, listen: false)
                          .onTapDelete(data['id']);
                    },
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3.0),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      //TODO: Review this part of code
                      Provider.of<ProjectsProvider>(context, listen: false)
                          .onTapViewProject(index);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: dx / 2 * maxW / 100,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsTable extends StatelessWidget {
  const ProjectsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final maxW = constrains.maxWidth;
        final spaces = [5, 15, 12, 8, 8, 10, 12, 15];
        return Consumer<ProjectsProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProjectsTableHeader(
                  spaces: spaces,
                  dx: 1,
                  maxW: maxW,
                ),
                Expanded(
                  child: PaginatedWidget(
                    infoText: " ${provider.prjs.length} Proyectos",
                    itemCount: provider.prjs.length,
                    itemsPerPage: 8,
                    onRefresh: () async {
                      provider.updateProjects();
                    },
                    itemBuilder: (context, index) {
                      return ProjectsTableRow(
                        data: provider.prjs[index],
                        spaces: spaces,
                        index: index,
                        dx: 1,
                        maxW: maxW,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 75,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
