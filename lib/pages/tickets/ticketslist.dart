import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketstable.dart';
import 'package:app_movil_dincydet/providers/tickets/tickets_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({
    super.key,
    required this.ticketsin,
  });

  final bool ticketsin;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketsPageProvider>(
      create: (context) => TicketsPageProvider(ticketsin ? 'in' : 'out'),
      child: MyScaffold(
        title: ticketsin ? 'Tickets recibidos' : 'Tickets emitidos',
        section: ticketsin ? DrawerSection.ticketsin : DrawerSection.ticketsout,
        fab: Consumer<TicketsPageProvider>(
          builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: MC_lightblue,
                  onPressed: () {
                    provider.onTapNewTicket();
                  },
                  icon: const Icon(Icons.add),
                  heroTag: null,
                  label: const Text(
                    'Crear Ticket',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    provider.onTapOpenClose();
                  },
                  label: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: provider.opentickets ? Colors.green : Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        provider.opentickets ? 'Abiertos' : 'Cerrados',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  heroTag: null,
                )
              ],
            );
          },
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Consumer<TicketsPageProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: provider.searchController,
                          onChanged: provider.onChangeSearch,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                            ),
                            hintText: 'Buscar Usuario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(
                        bottom: 50,
                      ),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: max(500, widthDevice - 60),
                                  color: Colors.grey.shade100,
                                  child: TabBar(
                                    labelColor: Colors.blue,
                                    indicatorColor: Colors.blue,
                                    indicator: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    tabs: [
                                      Tab(
                                        text:
                                            'Seguridad (${provider.tcount[0]})',
                                      ),
                                      Tab(
                                        text:
                                            'Proyecto (${provider.tcount[1]})',
                                      ),
                                      Tab(
                                        text: 'Falta (${provider.tcount[2]})',
                                      ),
                                      Tab(
                                        text: 'Tarea (${provider.tcount[3]})',
                                      ),
                                    ],
                                    onTap: provider.onTapChangeType,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: max(
                                          920,
                                          widthDevice -
                                              60), // suma de paddings:60
                                      child: TicketsTable(
                                        ticketsin: ticketsin,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
