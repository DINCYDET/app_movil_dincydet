import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/tickets/ticketsview_provider.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

class TicketsView extends StatelessWidget {
  const TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketsViewProvider>(
      create: (context) => TicketsViewProvider(),
      child: Consumer<TicketsViewProvider>(
        builder: (context, provider, child) {
          return MyScaffold(
            title: 'Mis Tickets',
            section: DrawerSection.ticketsin,
            fab: FloatingActionButton(
              backgroundColor: const Color(0xFF081929),
              onPressed: provider.onPressed,
              child: const Icon(Icons.refresh),
            ),
            body: Padding(
              padding: const EdgeInsets.all(40),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tickets Pendientes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: provider.childrenin,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tickets Generados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: provider.childrenout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TicketCardT1 extends StatelessWidget {
  TicketCardT1({
    super.key,
    required this.data,
    required this.saveFile,
    required this.viewFile,
  });
  final Map<String, dynamic> data;
  final void Function(
    String filename,
    BuildContext context,
  ) saveFile;
  final void Function(
    String filename,
    String filetype,
    BuildContext context,
  ) viewFile;
  final List<Color> colors = [
    Colors.black,
    Colors.green,
    Colors.amber,
    Colors.red
  ];
  final List<String> priorities = ['Zero', 'Baja', 'Media', 'Alta'];
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: colors[data['priority']].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'Ticket de proyecto',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[data['priority']],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Prioridad ${priorities[data['priority']]}',
                          style: TextStyle(color: colors[data['priority']]),
                        ),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Generado por:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImageBuilder(
                            //url: '${apiBase}uploads/users/${data['userphoto']}',
                            url: data['userphoto'],
                            builder: ((image) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.cover)),
                              );
                            }),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['userpos'],
                                style: const TextStyle(fontSize: 13.0),
                              ),
                              Text(
                                data['date'],
                                style: const TextStyle(
                                    fontSize: 11.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre del Proyecto',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 5.0,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripcion',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AspectRatio(
                        aspectRatio: 2.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Text(data['ticketname']),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Documentos adjuntos',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AspectRatio(
                        aspectRatio: 2.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['doc'],
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      child: IconButton(
                                        splashRadius: 14.0,
                                        iconSize: 18.0,
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(
                                          Icons.download,
                                        ),
                                        onPressed: () {
                                          saveFile(data['doc'], context);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      child: IconButton(
                                        splashRadius: 14.0,
                                        iconSize: 18.0,
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          size: 18.0,
                                        ),
                                        onPressed: () {
                                          viewFile(data['doc'],
                                              data['filetype'], context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(),
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
            const Divider(),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Abrir chat')
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: const Text('Marcar Completado'),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class TicketCardT2 extends StatelessWidget {
  TicketCardT2({
    super.key,
    required this.data,
    required this.saveFile,
    required this.viewFile,
  });
  final Map<String, dynamic> data;
  final void Function(
    String filename,
    BuildContext context,
  ) saveFile;
  final void Function(
    String filename,
    String filetype,
    BuildContext context,
  ) viewFile;
  final List<Color> colors = [
    Colors.black,
    Colors.green,
    Colors.amber,
    Colors.red
  ];
  final List<String> priorities = ['Zero', 'Baja', 'Media', 'Alta'];
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: colors[data['priority']].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'Ticket de proyecto',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[data['priority']],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Prioridad ${priorities[data['priority']]}',
                          style: TextStyle(color: colors[data['priority']]),
                        ),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Enviado a:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImageBuilder(
                            //url: '${apiBase}uploads/users/${data['userphoto']}',
                            url: data['userphoto'],
                            builder: ((image) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.cover)),
                              );
                            }),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['userpos'],
                                style: const TextStyle(fontSize: 13.0),
                              ),
                              Text(
                                data['date'],
                                style: const TextStyle(
                                    fontSize: 11.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre del Proyecto',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 5.0,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripcion',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AspectRatio(
                        aspectRatio: 2.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Text(data['ticketname']),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Documentos adjuntos',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AspectRatio(
                        aspectRatio: 2.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['doc'],
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      child: IconButton(
                                        splashRadius: 14.0,
                                        iconSize: 18.0,
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(
                                          Icons.download,
                                        ),
                                        onPressed: () {
                                          saveFile(data['doc'], context);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                      child: IconButton(
                                        splashRadius: 14.0,
                                        iconSize: 18.0,
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          size: 18.0,
                                        ),
                                        onPressed: () {
                                          viewFile(data['doc'],
                                              data['filetype'], context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(),
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
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Abrir chat')
                    ],
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estado Ticket',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Progresso(
                        progress: 0.5,
                        points: const [0.25, 0.5, 0.75],
                        progressStrokeCap: StrokeCap.round,
                        backgroundStrokeCap: StrokeCap.round,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
