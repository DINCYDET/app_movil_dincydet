import 'dart:async';
import 'dart:io';

import 'package:app_movil_dincydet/api/api_tickets.dart';
import 'package:app_movil_dincydet/api/messages/api_messages.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/tickets/ticketdetail.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainticket_provider.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as ctypes;
import 'package:uuid/uuid.dart';

class TicketDetailProvider extends ChangeNotifier {
  int ticketid = Provider.of<MainTicketProvider>(navigatorKey.currentContext!,
          listen: false)
      .ticketId!;
  int userid =
      Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
          .USERDATA!['DNI'];

  TicketDetailProvider() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initMessages();
      subscribeToMessages();
    });
  }

  late ctypes.User user = ctypes.User(
    id: Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA!['DNI']
        .toString(),
    firstName:
        Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
            .USERDATA?['FULLNAME'],
  );

  bool loadedData = false;

  Future<String> getDocsPath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    return appDocumentsPath;
  }

  void saveFile(String uri, String filename, BuildContext context) async {
    try {
      Response<dynamic> response = await Dio().get(
        //'${apiBase}uploads/tickets/$filename',
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      String path = await getDocsPath();
      File file = File(join(path, filename));
      file.writeAsBytes(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descarga completa: ${file.path}'),
        ),
      );
    } catch (e) {
      return;
      //print(e);
    }
  }

  void viewFile(String filename, String filetype, BuildContext context) async {
    //final String extension = filename.split('.')[1];
    // TODO: Pass data in provider
    if (filetype == 'img') {
      Navigator.of(context).pushNamed('/previewimg');
    } else if (filetype == 'pdf') {
      Navigator.of(context).pushNamed('/previewpdf');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede visualizar'),
        ),
      );
    }
  }

  // For chat
  List<ctypes.Message> messages = [];
  List<Map<String, dynamic>> files = [];

  void initMessages() async {
    Map<String, dynamic>? response = await apiMessagesGet(ticketid);
    if (response == null) {
      return;
    }
    final data = response['messages'];
    messages = List.generate(data.length, (i) {
      final msg = data[i];
      return parseMessage(msg);
    });
    searchFiles();
    notifyListeners();
  }

  void searchFiles() {
    files = [];
    for (ctypes.Message msg in messages) {
      if (msg.type == ctypes.MessageType.file ||
          msg.type == ctypes.MessageType.image) {
        final msgdata = msg.toJson();
        final name = (msgdata['name'] as String).split('.');
        String extension = name[name.length - 1];
        if (extension == 'jpg' || extension == 'png' || extension == 'jpeg') {
          extension = 'img';
        }
        files.add({
          'name': msgdata['name'],
          'uri': msgdata['uri'],
          'type': extension,
        });
      }
    }
    notifyListeners();
  }

  ctypes.Message parseMessage(Map<String, dynamic> msg) {
    if (msg['TYPE'] == MsgTypes.image.index) {
      String parameters = msg['DATA'] as String;
      List<String> params = parameters.split('|');
      return ctypes.ImageMessage(
          id: msg['ID'],
          createdAt: msg['CREATEDAT'],
          author: ctypes.User(
            id: msg['AUTHOR'].toString(),
          ),
          uri: msg['URI'],
          name: params[0],
          size: int.parse(params[1]),
          width: double.parse(params[2]),
          height: double.parse(params[3]));
    } else if (msg['TYPE'] == MsgTypes.file.index) {
      String parameters = msg['DATA'] as String;
      List<String> params = parameters.split('|');
      return ctypes.FileMessage(
        id: msg['ID'],
        createdAt: msg['CREATEDAT'],
        author: ctypes.User(
          id: msg['AUTHOR'].toString(),
        ),
        uri: msg['URI'],
        name: params[0],
        size: int.parse(params[1]),
      );
    }
    return ctypes.TextMessage(
        id: msg['ID'],
        createdAt: msg['CREATEDAT'],
        author: ctypes.User(
          id: msg['AUTHOR'].toString(),
        ),
        text: msg['TEXT']);
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('Dispose Ticket provider');
    }
    try {
      Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
          .leaveTicket(ticketid);
      messagesStream?.cancel();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    super.dispose();
  }

  StreamSubscription? messagesStream;
  void subscribeToMessages() {
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .joinToTicket(ticketid);
    messagesStream =
        Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
            .MessagesStream
            .listen((event) {
      final message = parseMessage(event);
      messages.insert(0, message);
      searchFiles();
      notifyListeners();
    });
  }

  void handleSendPressed(ctypes.PartialText message) {
    final textMessage = ctypes.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    addMessage(textMessage);
  }

  void addMessage(ctypes.Message message) async {
    //messages.insert(0, message);
    Map<String, dynamic> dataMap = {
      'ID': message.id,
      'CHATID': ticketid,
      'AUTHOR': message.author.id,
      'CREATEDAT': message.createdAt,
      'TYPE': MsgTypes.text.index,
    };
    final data = message.toJson();
    if (message.type == ctypes.MessageType.text) {
      dataMap['TEXT'] = data['text'];
    } else if (message.type == ctypes.MessageType.file) {
      dataMap['SIZE'] = data['size'];
      dataMap['NAME'] = data['name'];
      dataMap['TYPE'] = MsgTypes.file.index;
      dataMap['files'] = [
        await MultipartFile.fromFile(
          data['uri'],
          filename: data['name'],
        )
      ];
    } else if (message.type == ctypes.MessageType.image) {
      dataMap['SIZE'] = data['size'];
      dataMap['NAME'] = data['name'];
      dataMap['HEIGHT'] = data['height'].toInt();
      dataMap['WIDTH'] = data['width'].toInt();
      dataMap['TYPE'] = MsgTypes.image.index;
      dataMap['files'] = [
        await MultipartFile.fromFile(
          data['uri'],
          filename: data['name'],
        )
      ];
    }
    Map<String, dynamic>? response = await apiMessagesAdd(dataMap);
    if (response == null) {
      return;
    }
    //notifyListeners();
  }

  void handleImageSelection() async {
    // With image picker for movil
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      return;
    }
    File file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final message = ctypes.ImageMessage(
      author: user,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      height: image.height.toDouble(),
      width: image.width.toDouble(),
      id: const Uuid().v4(),
      name: basename(file.path),
      uri: file.path,
      size: bytes.length,
    );
    addMessage(message);
  }

  void handleFileSelection() async {
    // With image picker for movil
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) {
      return;
    }

    final extension = result.files.single.extension;

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      File file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = ctypes.ImageMessage(
        author: user,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        height: image.height.toDouble(),
        width: image.width.toDouble(),
        id: const Uuid().v4(),
        name: basename(file.path),
        uri: file.path,
        size: bytes.length,
      );
      addMessage(message);
    } else {
      final message = ctypes.FileMessage(
          author: user,
          createdAt: DateTime.now().microsecondsSinceEpoch,
          id: const Uuid().v4(),
          name: result.files.single.name,
          size: result.files.single.size,
          uri: result.files.single.path!);
      addMessage(message);
    }
  }

  void onTapCloseTicket() async {
    //TODO: Code to close ticket
    final result = await apiTicketsClose(ticketid);
    if (result == null) {
      return;
    }
    Navigator.pop(navigatorKey.currentContext!, true);
  }

  void onTapMessage(BuildContext context, ctypes.Message message) {
    // TODO: Code to download file
  }
}
