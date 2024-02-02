import 'dart:io';
import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/widgets/userphoto.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:matrix/matrix.dart';

final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.event,
    required this.client,
    required this.timeline,
  });
  final Event event;
  final Client client;
  final Timeline timeline;

  @override
  Widget build(BuildContext context) {
    print(event.messageType);
    print(event.text);
    //event.downloadAndDecryptAttachment();
    print(event.attachmentOrThumbnailMxcUrl()?.getDownloadLink(client));
    print('-------------------');
    final bool isMe = event.senderFromMemoryOrFallback.id == client.userID;
    final Color color = isMe ? AppColors.primaryColor : CupertinoColors.white;
    final Color textColor =
        isMe ? CupertinoColors.white : CupertinoColors.black;
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 25 : 0,
        right: isMe ? 0 : 25,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMe)
            Align(
              alignment: Alignment.bottomLeft,
              child: UserPhoto(
                avatar: event.senderFromMemoryOrFallback.avatarUrl,
                client: client,
                radius: 12,
              ),
            ),
          if (!isMe)
            const SizedBox(
              width: 10,
            ),
          Flexible(
            child: Opacity(
              opacity: event.status.isSent ? 1 : 0.5,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomRight: isMe ? Radius.zero : const Radius.circular(10),
                    bottomLeft: isMe ? const Radius.circular(10) : Radius.zero,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: color,
                ),
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${event.senderFromMemoryOrFallback.displayName ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? CupertinoColors.white
                              : AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (event.messageType == 'm.image')
                        FutureBuilder(
                          future: event.downloadAndDecryptAttachment(
                              getThumbnail: true),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final data = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onDoubleTap: () =>
                                      onDoubleTapAttachment(event),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Image.memory(data.bytes),
                                  ),
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      if (event.messageType == 'm.file')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isMe
                                          ? CupertinoColors.white
                                          : AppColors.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => onDoubleTapAttachment(event),
                                    child: Icon(
                                      CupertinoIcons.cloud_download_fill,
                                      size: 64,
                                      color: isMe
                                          ? CupertinoColors.white
                                          : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    event.text,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: isMe
                                          ? CupertinoColors.white
                                          : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Text(
                        event.getDisplayEvent(timeline).body,
                        maxLines: 50,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            dateFormat.format(event.originServerTs),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDoubleTapAttachment(Event event) async {
    // Show cupertino dialog to confirm download
    final bool? download = await showCupertinoDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Descargar'),
          content: const Text('¿Desea descargar el archivo adjunto?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              child: const Text('Descargar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (download != true) return;
    // Download attachment
    final attachment = await event.downloadAndDecryptAttachment();
    // Save attachment to gallery
    final Directory? directory = await DownloadsPath.downloadsDirectory();
    if (directory == null) return;
    final String path = directory.path;
    final String filename = event.text;
    final File file = File('$path/$filename');
    await file.writeAsBytes(attachment.bytes);
    // Show cupertino snackbar
    Fluttertoast.showToast(
      msg: "Descarga completada",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.primaryColor,
      textColor: CupertinoColors.white,
      fontSize: 16.0,
    );
  }
}

class ServerMessageWidget extends StatelessWidget {
  const ServerMessageWidget({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    if (eventOccurred == null) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: CupertinoColors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Text(
              eventOccurred!,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get username {
    final String? displayName = event.senderFromMemoryOrFallback.displayName;
    final String userId = event.senderFromMemoryOrFallback.id;
    if (displayName != null) {
      return displayName;
    } else {
      return userId;
    }
  
  }

  String? get eventOccurred {
    final eventType = event.type;
    switch (eventType) {
      case 'm.room.member':
        return '🚪 $username se unió al chat';
      case 'm.room.create':
        return '📝 $username creó el chat';
      case 'm.room.encryption':
        return '🔐 $username activó el cifrado de extremo a extremo';
    }
    return null;
  }
}
