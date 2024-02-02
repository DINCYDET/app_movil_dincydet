import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/my_rooms/room.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/cryptonaval/utils/date_utils.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class MessageRoomsListPage extends StatefulWidget {
  const MessageRoomsListPage({super.key});

  @override
  State<MessageRoomsListPage> createState() => _MessageRoomsListPageState();
}

class _MessageRoomsListPageState extends State<MessageRoomsListPage> {
  final client = Provider.of<CryptoMainProvider>(navigatorKey.currentContext!,
          listen: false)
      .client;

  @override
  void initState() {
    super.initState();
    client.sync();
  }

  @override
  Widget build(BuildContext context) {
    final userId = client.userID;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primaryColor,
        leading: _isSelecting
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _onTapClearSelection,
                child: const Icon(
                  CupertinoIcons.clear,
                  color: Colors.white,
                ),
              )
            : CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 20,
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
        middle: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                _isSelecting ? _roomsSelected.length.toString() : 'Mis chats',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            if (_isSelecting)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onTapDeleteRooms,
                child: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                ),
              ),
            Material(
              color: Colors.transparent,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text(
                        'Nuevo grupo',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        'Ajustes',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onTapOptions,
                  dropdownStyleData: const DropdownStyleData(
                    width: 150,
                    decoration: BoxDecoration(
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  CupertinoSearchTextField(
                    placeholder: 'Buscar mensaje o contacto',
                    onChanged: onChangedSearch,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: client.onSync.stream,
                      initialData: SyncUpdate(nextBatch: ""),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final rooms = getMessagesRooms;
                          return ListView.builder(
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              String chatName = room.getLocalizedDisplayname();
                              if (room.isDirectChat) {
                                final users = room.getParticipants();
                                for (final user in users) {
                                  if (user.id != userId) {
                                    chatName = user.displayName ?? user.id;
                                    break;
                                  }
                                }
                              }
                              // print(client.directChats);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: SizedBox(
                                  height: 60,
                                  child: GestureDetector(
                                    onLongPress: () => onLongPressRoom(room),
                                    child: CupertinoListTile(
                                      leadingSize: 50,
                                      leading: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor:
                                                CupertinoColors.systemGrey,
                                            child: ClipOval(
                                              child: room.avatar == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 36,
                                                    )
                                                  : ExtendedImage.network(
                                                      room.avatar!
                                                          .getThumbnail(client,
                                                              width: 56,
                                                              height: 56)
                                                          .toString(),
                                                      loadStateChanged:
                                                          (state) {
                                                        switch (state
                                                            .extendedImageLoadState) {
                                                          case LoadState
                                                                .loading:
                                                            return const CupertinoActivityIndicator();
                                                          case LoadState
                                                                .completed:
                                                            return ExtendedRawImage(
                                                              image: state
                                                                  .extendedImageInfo
                                                                  ?.image,
                                                            );
                                                          case LoadState.failed:
                                                            return const Icon(
                                                              CupertinoIcons
                                                                  .person,
                                                              color:
                                                                  Colors.white,
                                                            );
                                                        }
                                                      },
                                                    ),
                                            ),
                                          ),
                                          if (_roomsSelected.contains(room))
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CupertinoColors
                                                      .systemGreen,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  CupertinoIcons.check_mark,
                                                  color: CupertinoColors.white,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chatName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          Text(
                                            isoDateTimeToTimeOrDay(room
                                                .lastEvent?.originServerTs
                                                .toIso8601String()),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: room.notificationCount > 0
                                                  ? CupertinoColors.activeBlue
                                                  : AppColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              room.lastEvent?.content['body']
                                                      .toString() ??
                                                  'Sin mensajes',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          if (room.notificationCount > 0)
                                            Container(
                                              width: 24,
                                              height: 24,
                                              margin: const EdgeInsets.only(
                                                  left: 10.0),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    CupertinoColors.activeBlue,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                room.notificationCount < 99
                                                    ? room.notificationCount
                                                        .toString()
                                                    : '99+',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: CupertinoColors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                      onTap: () => onTapRoom(room),
                                    ),
                                  ),
                                ),
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
              Positioned(
                bottom: 20,
                right: 20,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onTapNewRoom,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(
                      CupertinoIcons.pencil,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get getMessagesRoomsCount {
    final rooms = client.rooms;
    int count = 0;
    for (var room in rooms) {
      if (room.name.startsWith('!')) {
        continue;
      }
      count += 1;
    }
    return count;
  }

  List<Room> get getMessagesRooms {
    final rooms = client.rooms;
    final messagesRooms = <Room>[];
    for (var room in rooms) {
      if (room.name.startsWith('!')) {
        continue;
      }
      messagesRooms.add(room);
    }
    return messagesRooms;
  }

  void onTapRoom(Room room) async {
    if (_isSelecting) {
      onLongPressRoom(room);
      return;
    }

    if (room.membership != Membership.join) {
      await room.join();
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => RoomPage(room: room),
      ),
    );
  }

  // --------- Long Press Actions ---------
  final List<Room> _roomsSelected = [];
  bool get _isSelecting => _roomsSelected.isNotEmpty;
  void onLongPressRoom(Room room) async {
    if (_isSelecting) {
      if (_roomsSelected.contains(room)) {
        _roomsSelected.remove(room);
      } else {
        _roomsSelected.add(room);
      }
    } else {
      _roomsSelected.add(room);
    }
    setState(() {});
  }

  void onTapNewRoom() {
    Navigator.of(context).pushNamed('/users_list');
  }

  void onTapMore() {}

  void onChangedSearch(String value) {}

  void _onTapClearSelection() {
    _roomsSelected.clear();
    setState(() {});
  }

  void onTapDeleteRooms() async {
    // Confirm the action
    bool? complete = await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
            'Eliminar ${_roomsSelected.length} chat${_roomsSelected.length > 1 ? 's' : ''}'),
        content: const Text('¿Estás seguro de eliminar los chats?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (complete != true) return;
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    for (final room in _roomsSelected) {
      client.leaveRoom(room.id);
    }
    _roomsSelected.clear();
  }

  void onTapOptions(int? value) {
    switch (value) {
      case 0: // Nuevo grupo
        break;
      case 1: // Ajustes
        Navigator.of(context).pushNamed('/settings');
        break;
    }
  }
}
