import 'dart:io';

import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/pages/my_rooms/room.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrix/matrix.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String userFilter = '';
  TextEditingController searchController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primaryColor,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 20,
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: const Text(
          'Usuarios en la red',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    placeholder: 'Buscar Usuario',
                    controller: searchController,
                    onChanged: onChangedSearch,
                  ),
                  const SizedBox(height: 20),
                  material.Visibility(
                    visible: !addingGroup,
                    child: CupertinoButton(
                      onPressed: onTapNewGroup,
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                CupertinoIcons.group_solid,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              'Nuevo Grupo',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lista de Usuarios',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemGrey,
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder(
                      future: client.searchUserDirectory(userFilter, limit: 50),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final SearchUserDirectoryResponse data =
                              snapshot.data!;
                          return ListView.builder(
                            itemCount: data.results.length,
                            itemBuilder: (context, index) {
                              final user = data.results[index];
                              return CupertinoListTile(
                                leadingSize: 50,
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: CupertinoColors.systemGrey,
                                  child: user.avatarUrl != null
                                      ? ClipOval(
                                          child: ExtendedImage.network(
                                            user.avatarUrl!
                                                .getThumbnail(client,
                                                    width: 56, height: 56)
                                                .toString(),
                                            loadStateChanged: (state) {
                                              switch (state
                                                  .extendedImageLoadState) {
                                                case LoadState.loading:
                                                  return const CupertinoActivityIndicator();
                                                case LoadState.completed:
                                                  return ExtendedRawImage(
                                                    image: state
                                                        .extendedImageInfo
                                                        ?.image,
                                                  );
                                                case LoadState.failed:
                                                  return const Icon(
                                                    CupertinoIcons.person,
                                                    color: Colors.white,
                                                  );
                                              }
                                            },
                                          ),
                                        )
                                      : const Icon(
                                          CupertinoIcons.person,
                                          color: Colors.white,
                                        ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.displayName.toString(),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(user.userId.toString()),
                                onTap: () => onTapUser(user),
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
            material.Visibility(
              visible: addingGroup,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemGrey3,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              'Nuevo grupo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: CupertinoColors.black,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 24.0,
                            onPressed: onTapCancelNewGroup,
                            child: const Icon(
                              CupertinoIcons.clear,
                              color: CupertinoColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                        child: ClipOval(
                                          child: pickedImage != null
                                              ? Image.file(
                                                  pickedImage!,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  CupertinoIcons.group_solid,
                                                  color: Colors.white,
                                                  size: 80,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          minSize: 24.0,
                                          onPressed: onTapAddImage,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: CupertinoColors.white,
                                              border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.photo_camera_solid,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CupertinoTextField(
                                  controller: groupNameController,
                                  placeholder: 'Nombre del grupo',
                                ),
                                const SizedBox(height: 20),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  color: AppColors.primaryColor,
                                  onPressed: onTapCreateGroup,
                                  child: const Text(
                                    'Crear grupo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 2.0,
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            color: AppColors.primaryColor,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isPrivate
                                          ? 'Grupo privado'
                                          : 'Grupo público',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    CupertinoSwitch(
                                      value: isPrivate,
                                      onChanged: (value) {
                                        setState(() {
                                          isPrivate = value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Integrantes:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: selectedUsers.length,
                                    itemBuilder: (context, index) {
                                      final user = selectedUsers[index];
                                      return CupertinoListTile(
                                        leadingSize: 50,
                                        leading: CircleAvatar(
                                          radius: 24,
                                          backgroundColor:
                                              CupertinoColors.systemGrey,
                                          child: user.avatarUrl != null
                                              ? ClipOval(
                                                  child: ExtendedImage.network(
                                                    user.avatarUrl!
                                                        .getThumbnail(client,
                                                            width: 56,
                                                            height: 56)
                                                        .toString(),
                                                    loadStateChanged: (state) {
                                                      switch (state
                                                          .extendedImageLoadState) {
                                                        case LoadState.loading:
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
                                                            color: Colors.white,
                                                          );
                                                      }
                                                    },
                                                  ),
                                                )
                                              : const Icon(
                                                  CupertinoIcons.person,
                                                  color: Colors.white,
                                                ),
                                        ),
                                        trailing: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          minSize: 24.0,
                                          child: const Icon(
                                            CupertinoIcons.clear,
                                            color:
                                                CupertinoColors.destructiveRed,
                                          ),
                                          onPressed: () =>
                                              onTapRemoveUser(user),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                user.displayName.toString(),
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(user.userId.toString()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapUser(Profile user) async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    // Verificar si se esta creando un grupo
    if (addingGroup) {
      // Verificar si el usuario ya esta en el grupo
      if (selectedUsers.contains(user)) {
        return;
      }
      // Agregar usuario al grupo
      selectedUsers.add(user);
      setState(() {});
      return;
    }

    String roomId = await client.startDirectChat(user.userId);
    await client.joinRoomById(roomId);
    final Room? room = client.getRoomById(roomId);
    if (room == null) {
      print('Room is null');
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

  void onChangedSearch(String value) {
    setState(() {
      userFilter = value;
    });
  }

  // -------------------- New Group --------------------
  bool addingGroup = false;
  void onTapNewGroup() {
    setState(() {
      addingGroup = true;
    });
  }

  void onTapCancelNewGroup() {
    setState(() {
      addingGroup = false;
      pickedImage = null;
      groupNameController.clear();
      selectedUsers.clear();
      isPrivate = true;
    });
  }

  void onTapCreateGroup() async {
    final client =
        Provider.of<CryptoMainProvider>(context, listen: false).client;
    final groupName = groupNameController.text;
    if (groupName.isEmpty) {
      return;
    }
    final userIds = selectedUsers.map((e) => e.userId).toList();
    final roomId = await client.createGroupChat(
      groupName: groupName,
      preset: isPrivate
          ? CreateRoomPreset.privateChat
          : CreateRoomPreset.publicChat,
      invite: userIds,
    );
    client.joinRoom(roomId);
    final Room? room = client.getRoomById(roomId);

    if (room == null) {
      print('Room is null');
      return;
    }
    if (pickedImage != null) {
      final bytes = await pickedImage!.readAsBytes();
      final filename = pickedImage!.path.split('/').last;
      await room.setAvatar(MatrixFile(bytes: bytes, name: filename));
    }
    onTapCancelNewGroup();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => RoomPage(room: room),
      ),
    );
  }

  File? pickedImage;
  List<Profile> selectedUsers = [];
  bool isPrivate = true;

  void onTapAddImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Selecciona una imagen'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              // TODO: Implementar
            },
            child: const Text(
              'Cámara',
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop();
              FilePickerResult? results = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );
              if (results != null) {
                setState(() {
                  pickedImage = File(results.files.single.path!);
                });
              }
            },
            child: const Text(
              'Galería',
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  void onTapRemoveUser(Profile user) {
    selectedUsers.remove(user);
    setState(() {});
  }
}
