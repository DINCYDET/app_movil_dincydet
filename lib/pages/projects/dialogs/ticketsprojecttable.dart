import 'package:app_movil_dincydet/providers/tickets/tickets_provider.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketstable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TicketsProjectTable extends StatelessWidget {
  const TicketsProjectTable({
    super.key,
    required this.prjid,
  });

  final int prjid;
  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.8;
    final maxH = MediaQuery.of(context).size.height * 0.8;
    final spaces = [5, 24, 12, 10, 12, 10, 15];
    return ChangeNotifierProvider(
      //TODO : Review this part, code broken
      create: (context) => TicketsPageProvider('in'),
      child: SimpleDialog(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Consumer<TicketsPageProvider>(
                builder: (context, provider, child) {
              return Column(
                children: [
                  TicketsTableHeader(
                    spaces: spaces,
                    dx: 1,
                    maxW: maxW,
                    ticketsin: true,
                  ),
                  Expanded(
                    child: PaginatedWidget(
                      infoText: '${provider.tickets.length} Tickets',
                      itemCount: provider.tickets.length,
                      itemsPerPage: 8,
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
                            index: i,
                            ticketsin: true, //TODO: Fix this
                            data: provider.tickets[i],
                            spaces: spaces,
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
            }),
          )
        ],
      ),
    );
  }
}
