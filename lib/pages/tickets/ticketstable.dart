import 'package:app_movil_dincydet/providers/tickets/tickets_provider.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsTable extends StatelessWidget {
  const TicketsTable({
    super.key,
    required this.ticketsin,
  });

  final bool ticketsin;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final maxW = constrains.maxWidth;
        final spaces = [5, 24, 12, 10, 12, 10, 15];
        return Consumer<TicketsPageProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                TicketsTableHeader(
                  spaces: spaces,
                  dx: 1,
                  maxW: maxW,
                  ticketsin: ticketsin,
                ),
                Expanded(
                  child: PaginatedWidget(
                    infoText: '${provider.tickets.length} Tickets',
                    itemCount: provider.filteredTicketList.length,
                    itemsPerPage: 8,
                    onRefresh: () async {
                      provider.updateCount();
                      provider.updateTickets();
                    },
                    itemBuilder: (context, i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        )),
                        child: TicketsTableRow(
                          data: provider.filteredTicketList[i],
                          index: i,
                          spaces: spaces,
                          ticketsin: ticketsin,
                          dx: 1,
                          maxW: maxW,
                          onTapDelete: () => provider.onTapDelete(i),
                          onTapDetails: provider.onTapViewTicket,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TicketsTableHeader extends StatelessWidget {
  const TicketsTableHeader({
    super.key,
    required this.spaces,
    required this.dx,
    required this.maxW,
    required this.ticketsin,
  });
  final List<int> spaces;
  final int dx;
  final double maxW;
  final TextStyle headerstyle = const TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );
  final bool ticketsin;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(dx * 0.5 * maxW / 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[0] * maxW / 100,
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
            SizedBox(
              width: spaces[1] * maxW / 100,
              child: Text(
                'Nombre del Ticket',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[2] * maxW / 100,
              child: Text(
                'Estado',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[3] * maxW / 100,
              child: Text(
                'Prioridad',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[4] * maxW / 100,
              child: Text(
                'Fecha de emisión',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[5] * maxW / 100,
              child: Text(
                ticketsin ? 'Emitido por' : 'Enviado a',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[6] * maxW / 100,
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsTableRow extends StatelessWidget {
  TicketsTableRow({
    super.key,
    required this.data,
    required this.spaces,
    required this.dx,
    required this.maxW,
    required this.onTapDelete,
    required this.onTapDetails,
    required this.index,
    required this.ticketsin,
  });
  final TextStyle rowstyle = const TextStyle(fontSize: 16, color: Colors.blue);
  final List<String> priors = const ['P. Baja', 'P. Media', 'P. Alta'];
  final List<Color> pcolors = [Colors.green, Colors.yellow, Colors.red];
  final Map<String, dynamic> data;
  final List<int> spaces;
  final int dx;
  final double maxW;
  final int index;
  final void Function() onTapDelete;
  final void Function(int index) onTapDetails;
  final bool ticketsin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: dx * 0.5 * maxW / 100, vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[0] * maxW / 100,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MC_lightblue,
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
            width: spaces[1] * maxW / 100,
            child: Text(
              data['MODNAME'] ?? '',
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[2] * maxW / 100,
            child: Text(
              data['STATUS'] == 1 ? 'Cerrado' : 'Abierto',
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[3] * maxW / 100,
            child: Row(
              children: [
                Text(
                  priors[data['PRIORITY']],
                  style: TextStyle(
                    color: pcolors[data['PRIORITY']],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.info,
                  color: pcolors[data['PRIORITY']],
                )
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[4] * maxW / 100,
            child: Text(
              isoToLocalDateTime(data['DATE']),
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[5] * maxW / 100,
            child: Text(
              username,
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[6] * maxW / 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onTapDelete,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder()),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.delete_outline_outlined),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => onTapDetails(index),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder()),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.more_horiz),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
        ],
      ),
    );
  }

  String get username {
    if (ticketsin) {
      return data['FROMUSER']['FULLNAME'];
    } else {
      return data['TOUSER']['FULLNAME'];
    }
  }
}
