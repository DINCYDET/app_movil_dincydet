import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/my_rooms/room_utils.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/cryptonaval/widgets/userphoto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
    required this.room,
  });
  final Room room;
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _count = 0;
  final TextEditingController _sendController = TextEditingController();

  @override
  void initState() {
    joinIfNot();
    checkIfMessagesNotReaded();
    _timelineFuture = widget.room.getTimeline(
      onChange: (index) {
        print('on change $index');
        _listKey.currentState!.setState(() {});
      },
      onInsert: (insertID) {
        print('on insert $insertID');
        _listKey.currentState!.insertItem(insertID);
      },
      onRemove: (index) {
        print('on remove $index');
        _listKey.currentState!
            .removeItem(index, (context, animation) => Container());
      },
      onUpdate: () {
        print('on update');
        _listKey.currentState!.setState(() {});
      },
    );
    super.initState();
  }

  void _send() {
    if (_sendController.text.trim().isEmpty) return;
    widget.room.sendTextEvent(_sendController.text.trim());
    _sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    return PieCanvas(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.primaryColor,
          leading: SizedBox(
            height: 36,
            width: 36,
            child: Center(
              child: CupertinoButton(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: CupertinoColors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          trailing: SizedBox(
            width: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  minSize: 32,
                  onPressed: onTapVideoCall,
                  child: const Icon(
                    CupertinoIcons.videocam_fill,
                    color: CupertinoColors.white,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  minSize: 32,
                  onPressed: onTapVoiceCall,
                  child: const Icon(
                    CupertinoIcons.phone_badge_plus,
                    color: CupertinoColors.white,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  minSize: 32,
                  onPressed: onTapInfo,
                  child: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ),
          middle: Row(
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: UserPhoto(
                  avatar: widget.room.avatar,
                  client: client,
                ),
              ),
              Expanded(
                child: Text(
                  widget.room.getLocalizedDisplayname(),
                  style: const TextStyle(
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: _timelineFuture,
                    builder: (context, snapshot) {
                      final timeline = snapshot.data;

                      if (timeline == null) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      timeline.setReadMarker(); // Mark messages as read
                      _count = timeline.events.length;
                      return Column(
                        children: [
                          material.Visibility(
                            visible: timeline.canRequestHistory,
                            child: Center(
                              child: CupertinoButton(
                                child: const Text(
                                  'Cargar más...',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                onPressed: () => onTapLoadMore,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedList(
                              key: _listKey,
                              reverse: true,
                              initialItemCount: timeline.events.length,
                              itemBuilder: (context, index, animation) {
                                final event = timeline.events[index];

                                if (event.relationshipEventId != null) {
                                  return Container();
                                }
                                if (event.type != 'm.room.message') {
                                  return ServerMessageWidget(event: event);
                                }

                                return ScaleTransition(
                                  scale: animation,
                                  child: MessageWidget(
                                    client: client,
                                    event: event,
                                    timeline: timeline,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        child: PieMenu(
                          theme: const PieTheme(
                            delayDuration: Duration.zero,
                            buttonTheme: PieButtonTheme(
                              backgroundColor: AppColors.primaryColor,
                              iconColor: CupertinoColors.white,
                            ),
                          ),
                          actions: [
                            PieAction(
                              tooltip: 'Galeria',
                              onSelect: onTapSendPhoto,
                              child: const Icon(CupertinoIcons.camera),
                            ),
                            PieAction(
                              tooltip: 'Archivo',
                              onSelect: onTapSendFile,
                              child: const Icon(CupertinoIcons.doc),
                            ),
                            PieAction(
                              tooltip: 'Audio',
                              onSelect: () {},
                              child: const Icon(CupertinoIcons.recordingtape),
                            ),
                            PieAction(
                              tooltip: 'Ubicación',
                              onSelect: () {},
                              child: const Icon(CupertinoIcons.location),
                            ),
                          ],
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              CupertinoIcons.paperclip,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _sendController,
                          placeholder: 'Escribe un mensaje...',
                          onSubmitted: (value) => _send(),
                          suffix: CupertinoButton(
                            onPressed: _send,
                            child: const Icon(
                              CupertinoIcons.paperplane_fill,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Verify if the user joined the room
  bool get isJoined => widget.room.membership == Membership.invite;

  void joinIfNot() {
    final room = widget.room;
    if (!isJoined) {
      widget.room.join();
    }
  }

  void checkIfMessagesNotReaded() {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final room = widget.room;
    // room.notificationCount = 0;
  }

  void onTapVideoCall() {}

  void onTapVoiceCall() {}

  void onTapInfo() {}

  void onTapLoadMore(Timeline timeline) async {
    if (timeline.canRequestHistory) {
      timeline.requestHistory();
    }
  }

  void _onTapAttach() {}

  void onTapSendFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(lockParentWindow: true);
    print('Archivo seleccionado');
    if (result == null) return;
    final pickedFile = result.files.single;
    print('Bytes');
    final filename = result.files.single.name;
    final bytes = await XFile(pickedFile.path!).readAsBytes();
    final room = widget.room;
    print('Antes de enviar');
    room.sendFileEvent(MatrixFile(bytes: bytes, name: filename));
  }

  void onTapSendPhoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? results = await picker.pickImage(source: ImageSource.gallery);
    if (results == null) return;
    final bytes = await results.readAsBytes();
    final filename = results.name;
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final room = widget.room;
    room.sendFileEvent(MatrixImageFile(bytes: bytes, name: filename));
  }
}
