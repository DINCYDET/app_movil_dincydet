import 'package:app_movil_dincydet/cryptonaval/pages/dashboard/custom_scaffold.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:matrix/matrix.dart';

class PublicRoomsPage extends StatefulWidget {
  const PublicRoomsPage({super.key});

  @override
  State<PublicRoomsPage> createState() => _PublicRoomsPageState();
}

class _PublicRoomsPageState extends State<PublicRoomsPage> {
  PublicRoomQueryFilter queryFilter = PublicRoomQueryFilter(
    genericSearchTerm: '',
  );

  @override
  Widget build(BuildContext context) {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    return CustomScaffold(
      title: 'Grupos Publicos',
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: CupertinoSearchTextField(
                    placeholder: 'Buscar',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CupertinoButton(
                  onPressed: onTapAddRoom,
                  child: const Icon(
                    CupertinoIcons.add,
                    size: 25,
                  ),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: client.queryPublicRooms(filter: queryFilter),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final QueryPublicRoomsResponse data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.chunk.length,
                      itemBuilder: (context, index) {
                        final room = data.chunk[index];
                        return CupertinoListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  room.name.toString(),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => onTapRoom(room),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapRoom(PublicRoomsChunk room) {}

  void onTapAddRoom() async {
    // Show a selection dialog to choose the room type: public, private or join with link
    // Then, navigate to the selected room type page

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text('Salas'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/create_room'),
                child: const Text('Crear Sala Publica'),
              ),
              CupertinoActionSheetAction(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/create_room'),
                child: const Text('Crear Sala Privada'),
              ),
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pushNamed('/join_room'),
                child: const Text('Unirse a Sala'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              isDestructiveAction: true,
              child: const Text('Cancelar'),
            ),
          );
        });
  }
}
