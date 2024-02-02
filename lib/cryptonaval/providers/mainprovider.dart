import 'package:app_movil_dincydet/cryptonaval/pages/login/dialogs.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_movil_dincydet/cryptonaval/utils/navigator.dart';

const uuidGenerator = Uuid();
// String homeserverUrl = "https://sv-7FahANL0Ey.cloud.elastika.pe";
// String homeserverUrl = "http://192.168.18.6:8008";
// String homeserverUrl = "http://dincydet.investigacionmgp.pe:8008";
String homeserverUrl = "https://dincydet.investigacionmgp.pe:444";

class CryptoMainProvider extends ChangeNotifier {
  final clientID = uuidGenerator.v4();
  late Client client;
  final storage = const FlutterSecureStorage();
  CryptoMainProvider() {
    print('Creado cryptoprovider');
    client = Client(
      "DincydetChat",
      databaseBuilder: (_) async {
        final dir = await getApplicationSupportDirectory();
        final db = HiveCollectionsDatabase('matrix_database', dir.path);
        await db.open();
        print('Database built');
        return db;
      },
      supportedLoginTypes: {
        AuthenticationTypes.password,
      },
    );

    client.onLoginStateChanged.stream.listen((event) async {
      loginState = event;
      print('Login state changed: $event');
      if (event == LoginState.loggedIn) {
        // Go to rooms list
        if (navigatorKey.currentState?.currentRouteName ==
            '/crypto_dashboard') {
          return;
        }
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/crypto_dashboard', (route) => false);
      } else if (event == LoginState.loggedOut) {
        if (navigatorKey.currentState?.currentRouteName == '/crypto_login') {
          return;
        }
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/crypto_login', (route) => false);
      }
    });

    client.onEvent.stream.listen((event) {
      print(event);
    });
    initClient();
    print('Init client');
  }

  void initClient() async {
    final results = await client.checkHomeserver(Uri.parse(homeserverUrl));
    client.init();
  }

  void loginClient(String identifier, String password) async {
    LoginResponse? status;
    try {
      status = await client.login(
        LoginType.mLoginPassword,
        identifier: AuthenticationUserIdentifier(user: identifier),
        password: password,
      );
    } on MatrixException catch (e) {
      showCupertinoDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return ErrorDialog(message: e.errorMessage);
        },
      );
      return;
    }
  }

  LoginState loginState = LoginState.loggedOut;
}
