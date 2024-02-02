
import 'package:app_movil_dincydet/fb/fb_push.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/api/auth/api_login.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initProvider();
    });
  }
  Validator passwordController = const Validator(null, null);
  Validator usernameController = const Validator(null, null);
  bool visibility = false;

  void onTapEye() {
    visibility = !visibility;
    notifyListeners();
  }

  Future<bool> queryUpdates() async {
    return false;
    //TODO: Create a new update system
    // if (!Platform.isAndroid) {
    //   return false;
    // }
    // final results = await apiQueryLatestVersion();
    // if (results == null) return false;
    // final onlineVersion = results["version"];
    // // Get the current version of the running app
    // final localVersion = appCurrentVersion;
    // // Compare the versions
    // print("Online version: $onlineVersion");
    // print("Local version: $localVersion");
    // if (onlineVersion == localVersion) {
    //   return false;
    // } else {
    //   return true;
    // }
  }

  void initProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      return;
    }
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .TOKEN = token;

    // With the token, try update
    bool needUpdate = await queryUpdates();
    if (needUpdate) {
      Navigator.pushReplacementNamed(navigatorKey.currentContext!, '/update');
      return;
    }

    Map<String, dynamic>? data = await apiLoginToken();
    if (data == null) {
      prefs.remove('token');
      return;
    }
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = data;
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .setPermissions();
    // Iniciar la conexion con el socket
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .initSocket();
    // Send firebase token
    final firebaseToken = await FCM().getToken();
    if (firebaseToken != null) {
      await apiSendFirebaseToken(firebaseToken);
    }
    String route = '/home';
    if (!Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .isAdmin) {
      route = '/myuserpage';
    }
    Navigator.pushReplacementNamed(navigatorKey.currentContext!, route);
  }

  void changePass(String password) {
    if (password.isNotEmpty) {
      passwordController = Validator(password, null);
    } else if (password.isEmpty) {
      passwordController = const Validator(null, null);
    } else {
      passwordController =
          const Validator(null, 'Debe tener almenos 1 caracter');
    }
    notifyListeners();
  }

  void changeUser(String username) {
    if (username.isEmpty) {
      usernameController = const Validator(null, null);
    } else if (username.length != 8) {
      usernameController = const Validator(null, 'Formato incorrecto');
    } else {
      usernameController = Validator(username, null);
    }
    notifyListeners();
  }

  void onTapLogin() async {
    if (passwordController.value == null || usernameController.value == null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text('Complete su usuario y contraseña'),
      ));
      return;
    }
    final Map<String, dynamic>? data = await apiLoginCredentials(
        usernameController.value!, passwordController.value!);
    if (data == null) return;
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = data;
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA!['PHOTOURL'] = data[
            'PHOTOURL'] ??
        'https://www.nicepng.com/png/detail/202-2022264_usuario-annimo-usuario-annimo-user-icon-png-transparent.png';
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .TOKEN = data['TOKEN'];
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .setPermissions();
    // Iniciar la conexion con el socket
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .initSocket();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data['TOKEN']);
    // Send firebase token
    final firebaseToken = await FCM().getToken();
    if (firebaseToken != null) {
      await apiSendFirebaseToken(firebaseToken);
    }
    // Code to route to user or admin
    String route = '/home';
    if (!Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .isAdmin) {
      route = '/myuserpage';
    }

    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      route,
    );
  }
}

class Validator {
  final String? value;
  final String? error;
  const Validator(this.value, this.error);
}
