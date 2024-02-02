import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold_dialog.dart';
import 'package:app_movil_dincydet/previews/qr_camera.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/src/utils/user_photo.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.title,
    required this.section,
    this.drawer = true,
    this.body,
    this.fab,
  });
  final String title;
  final Widget? body;
  final Widget? fab;
  final bool drawer;
  final DrawerSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: drawer
          ? SafeArea(
              child: Drawer(
                backgroundColor: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          UserPhotoWidget(
                            photo: Provider.of<MainProvider>(context,
                                    listen: false)
                                .USERDATA!['PHOTOURL'],
                            radius: 50,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<MainProvider>(context,
                                              listen: false)
                                          .USERDATA!['FULLNAME'] ??
                                      'Sin nombre',
                                  style: const TextStyle(
                                      color: Color(0xFF081929),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Admin',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MC_darkblue,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(navigatorKey.currentContext!);
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AssistanceDialog();
                                      },
                                    );
                                  },
                                  child: const Text('Asistencia'),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: Provider.of<MainProvider>(context, listen: false)
                          .isAdmin,
                      child: TileForDrawer(
                        icon: Icons.home,
                        label: 'Dashboard',
                        route: '/home',
                        select: section == DrawerSection.dashboard,
                      ),
                    ),
                    Visibility(
                      visible: Provider.of<MainProvider>(context, listen: false)
                          .isAdmin,
                      child: TileForDrawer(
                        icon: Icons.computer,
                        label: 'Tablero de accesos',
                        route: '/controlpanel',
                        select: section == DrawerSection.control,
                      ),
                    ),
                    TileForDrawer(
                      icon: Icons.person_pin,
                      label: 'Mi perfil',
                      route: '/myuserpage',
                      select: section == DrawerSection.own,
                    ),
                    TileForDrawer(
                      icon: Icons.pages_rounded,
                      label: 'Proyectos',
                      route: '/projects',
                      select: section == DrawerSection.projects,
                    ),
                    ExpansionTileForDrawer(
                      icon: Icons.group_work,
                      label: 'Personal',
                      children: [
                        TileForDrawer(
                          label: 'Papeletas',
                          route: '/documentspage',
                          select: section == DrawerSection.documents,
                        ),
                        Visibility(
                          visible:
                              Provider.of<MainProvider>(context, listen: false)
                                  .accessToPersonal,
                          child: TileForDrawer(
                            label: 'Oficina de personal',
                            route: '/personalpage',
                            select: section == DrawerSection.personal,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: Provider.of<MainProvider>(context, listen: false)
                              .accessToInventory ||
                          Provider.of<MainProvider>(context, listen: false)
                              .accessToBudget,
                      child: ExpansionTileForDrawer(
                        icon: Icons.stacked_bar_chart,
                        label: 'Administracion',
                        children: [
                          Visibility(
                            visible: Provider.of<MainProvider>(context,
                                    listen: false)
                                .accessToInventory,
                            child: TileForDrawer(
                                label: 'Inventario',
                                route: '/inventorypage',
                                select: section == DrawerSection.inventory),
                          ),
                          Visibility(
                            visible: Provider.of<MainProvider>(context,
                                    listen: false)
                                .accessToBudget,
                            child: TileForDrawer(
                              label: 'Presupuesto',
                              route: '/budgetpage',
                              select: section == DrawerSection.budget,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTileForDrawer(
                      icon: Icons.edit_document,
                      label: 'Gestion documentaria',
                      children: [
                        Visibility(
                          visible:
                              Provider.of<MainProvider>(context, listen: false)
                                  .accessToManagement,
                          child: TileForDrawer(
                            label: 'Doc. Recibidos',
                            route: '/docsreceivedpage',
                            select: section == DrawerSection.docsreceived,
                          ),
                        ),
                        Visibility(
                          visible:
                              Provider.of<MainProvider>(context, listen: false)
                                  .accessToManagement,
                          child: TileForDrawer(
                            label: 'Doc. Transmitidos',
                            route: '/docstransmittedpage',
                            select: section == DrawerSection.docstransmitted,
                          ),
                        ),
                        TileForDrawer(
                          label: 'Doc. Asignados',
                          route: '/docsassignedpage',
                          select: section == DrawerSection.docsassigned,
                        ),
                      ],
                    ),
                    ExpansionTileForDrawer(
                      icon: Icons.format_line_spacing,
                      label: 'Tickets',
                      children: [
                        TileForDrawer(
                          label: 'Tickets emitidos',
                          route: '/ticketsoutpage',
                          select: section == DrawerSection.ticketsout,
                        ),
                        TileForDrawer(
                          label: 'Tickets recibidos',
                          route: '/ticketsinpage',
                          select: section == DrawerSection.ticketsin,
                        ),
                      ],
                    ),
                    Visibility(
                      visible: Provider.of<MainProvider>(context, listen: false)
                          .isAdmin,
                      child: TileForDrawer(
                        icon: Icons.supervised_user_circle_outlined,
                        label: 'Usuarios',
                        route: '/userspage',
                        select: section == DrawerSection.users,
                      ),
                    ),
                    TileForDrawer(
                      icon: Icons.stacked_line_chart_outlined,
                      label: 'Indicadores de desempeño',
                      route: Provider.of<MainProvider>(context, listen: false)
                              .isAdmin
                          ? '/statsadminpage'
                          : '/statsuserpage',
                      select: section == DrawerSection.stats,
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('Cerrar sesion'),
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: (() async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('token');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      }),
                    )
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: fab,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: MC_darkblue,
        actions: [
          Visibility(
            visible: drawer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const PreviewCameraQR();
                        },
                      ));
                    },
                    child: const Icon(Icons.qr_code_scanner_sharp),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

class TileForDrawer extends StatelessWidget {
  const TileForDrawer({
    super.key,
    required this.label,
    required this.route,
    this.select = false,
    this.arguments,
    this.icon,
  });
  final String label;
  final IconData? icon;
  final String route;
  final Object? arguments;
  final bool select;

  static const color = Color(0xFF1D154A);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: select,
      iconColor: color,
      textColor: color,
      shape: select
          ? const Border(
              left: BorderSide(
              color: color,
              width: 5.0,
            ))
          : null,
      selectedTileColor: Colors.blue,
      selectedColor: Colors.white,
      leading: icon == null
          ? Container(
              width: 50,
            )
          : Icon(
              icon,
            ),
      title: Text(
        label,
      ),
      onTap: () {
        if (select) {
          return;
        }
        Navigator.pushReplacementNamed(context, route, arguments: arguments);
      },
    );
  }
}

class ExpansionTileForDrawer extends StatelessWidget {
  const ExpansionTileForDrawer({
    super.key,
    required this.label,
    required this.icon,
    required this.children,
  });
  final String label;
  final IconData? icon;
  final List<Widget> children;

  static const color = Color(0xFF1D154A);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(label),
      leading: Icon(
        icon,
      ),
      iconColor: color,
      textColor: color,
      collapsedIconColor: color,
      collapsedTextColor: color,
      children: children,
    );
  }
}

enum DrawerSection {
  dashboard,
  own,
  projects,
  documents,
  personal,
  inventory,
  budget,
  docsreceived,
  docstransmitted,
  docsassigned,
  ticketsout,
  ticketsin,
  users,
  stats,
  other,
  control,
}
