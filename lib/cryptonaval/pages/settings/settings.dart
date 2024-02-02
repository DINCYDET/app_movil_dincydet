import 'dart:io';
import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.primaryColor,
        middle: Text(
          'Configuración',
          style: TextStyle(
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onDoubleTap: onDoubleTapAvatar,
                    child: FutureBuilder(
                        future: getAvatarUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CupertinoColors.systemGrey,
                                  width: 2,
                                ),
                              ),
                              child: const CupertinoActivityIndicator(),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            final url = snapshot.data;
                            print(url);
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CupertinoColors.systemGrey,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  url!,
                                  loadStateChanged: (state) {
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.loading:
                                        return const CupertinoActivityIndicator();
                                      case LoadState.completed:
                                        return ExtendedRawImage(
                                          image: state.extendedImageInfo?.image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        );
                                      case LoadState.failed:
                                        return const Icon(
                                          CupertinoIcons.person,
                                          size: 40,
                                        );
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: CupertinoColors.systemGrey,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              CupertinoIcons.person,
                              size: 40,
                            ),
                          );
                        }),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.userID ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.none,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                            future: client.getDisplayName(client.userID!),
                            builder: (context, snapshot) {
                              String text = '';
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                text = 'Cargando...';
                              } else if (snapshot.hasData) {
                                text = snapshot.data ?? '';
                              }
                              return Text(
                                text,
                                style: const TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                  decoration: TextDecoration.none,
                                  fontSize: 16.0,
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CupertinoButton(
                    onPressed: onTapQRCode,
                    child: const Icon(
                      CupertinoIcons.qrcode,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: CupertinoColors.systemGrey.withOpacity(0.5),
                      height: 1,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                onPressed: onTapLogout,
                child: const SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Icon(
                          Icons.logout,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                fontSize: 18,
                                color: CupertinoColors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Es posible que se pierda la información guardada en el dispositivo',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getAvatarUrl() async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final Uri? url = await client.getAvatarUrl(client.userID!);
    print(url);
    if (url == null) return null;
    Uri value = url.getThumbnail(
      client,
      width: 100,
      height: 100,
    );
    return value.toString();
  }

  void onDoubleTapAvatar() async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    // Confirm dialog to change avatar
    bool? complete = await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Cambiar avatar'),
          content: const Text('¿Desea cambiar su avatar?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (complete != true) return;
    // Show action sheet to select image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    File file = File(result.files.single.path!);
    final filename = result.files.single.name;
    final matrixFile =
        MatrixImageFile(bytes: file.readAsBytesSync(), name: filename);
    await client.setAvatar(matrixFile);

    setState(() {});
  }

  void onTapQRCode() {}

  void onTapLogout() {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    client.logoutAll();
  }

  void getUserProfile() async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final userdata = await client.getUserProfile(client.userID!);
  }
}
