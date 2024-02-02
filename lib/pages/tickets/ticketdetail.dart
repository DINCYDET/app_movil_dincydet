// ignore_for_file: use_build_context_synchronously

import 'package:app_movil_dincydet/pages/tickets/ticketdetail_utils.dart';
import 'package:app_movil_dincydet/providers/tickets/ticketdetail_provider.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:provider/provider.dart';

class TicketsViewDialog extends StatelessWidget {
  TicketsViewDialog({
    super.key,
    required this.ticketdata,
    required this.isEmitted,
  });
  final Map<String, dynamic> ticketdata;
  final bool isEmitted;
  final List<Color> colors = [Colors.green, Colors.amber, Colors.red];
  final List<String> priorities = ['Baja', 'Media', 'Alta'];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketDetailProvider>(
      create: (context) => TicketDetailProvider(),
      child: Consumer<TicketDetailProvider>(
        builder: (context, provider, child) {
          return SimpleDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: colors[ticketdata['PRIORITY'] ?? 1].withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ticket de ${Ttypes.values[ticketdata['TYPE']].name}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[ticketdata['PRIORITY']],
                        ),
                      ),
                      Text(
                        'Prioridad ${priorities[ticketdata['PRIORITY']]}',
                        style: TextStyle(color: colors[ticketdata['PRIORITY']]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(20.0),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generado por:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImageBuilder(
                          url: ticketdata['FROMUSER']['PHOTOURL'] ?? '-',
                          builder: ((image) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                          errorWidget: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticketdata['FROMUSER']['FULLNAME'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                isoToLocalDateTime(ticketdata['DATE']),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Nombre del Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(ticketdata['NAME']),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Descripcion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(ticketdata['DESCRIPTION']),
                    ),
                    Visibility(
                      visible: isEmitted && ticketdata['STATUS'] == 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF101139),
                            ),
                            onPressed: provider.onTapCloseTicket,
                            child: const Text('Cerrar Ticket'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Card(
                        elevation: 10,
                        child: Chat(
                          messages: provider.messages,
                          onSendPressed: provider.handleSendPressed,
                          user: provider.user,
                          onAttachmentPressed: provider.handleFileSelection,
                          showUserNames: true,
                          showUserAvatars: true,
                          onMessageTap: provider.onTapMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String urltoname(String url) {
  final spliturl = url.split('/');
  final name = spliturl[spliturl.length - 1];
  return name;
}

enum MsgTypes { text, image, file }
