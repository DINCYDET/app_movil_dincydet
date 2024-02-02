import 'package:app_movil_dincydet/api/urls.dart';
import 'package:app_movil_dincydet/src/utils/userinfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMainButton extends StatelessWidget {
  const MyMainButton({
    super.key,
    required this.label,
    required this.color,
    this.onPress,
  });
  final String label;
  final Color color;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
          padding:
              const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(12.0)),
          backgroundColor: MaterialStatePropertyAll<Color>(color),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: color))),
          maximumSize: const MaterialStatePropertyAll<Size>(Size(200, 60)),
          minimumSize: const MaterialStatePropertyAll<Size>(Size(200, 60))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          )),
          const ClipOval(
            child: Material(
                color: Colors.white,
                child: Icon(
                  Icons.arrow_right_alt_outlined,
                  size: 36.0,
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.args});
  final UserArguments args;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ChangeNotifierProvider<RegisterButtonProvider>(
          create: (context) => RegisterButtonProvider()..getInfo(args.userid),
          child: Consumer<RegisterButtonProvider>(
            builder: (context, provider, child) {
              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: provider.color,
                ),
                child: provider.child,
                onPressed: () {
                  provider.onPressed(context, args);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class RegisterButtonProvider extends ChangeNotifier {
  Color color = Colors.black;
  bool ingreso = true;
  Widget child = const CircularProgressIndicator(
    color: Colors.white,
  );
  bool finished = false;
  void onPressed(BuildContext context, UserArguments args) {
    if (!finished) {
      return;
    }
    if (ingreso) {
      args.other = 'in';
    } else {
      args.other = 'out';
    }
    Navigator.pushNamed(context, '/setstatus', arguments: args);
  }

  void getInfo(String dni) async {
    Response<dynamic>? response = await queryStatus();
    if (response == null) {
      child = const Icon(
        Icons.error,
        color: Colors.white,
      );
      notifyListeners();
      return;
    }
    finished = true;
    List<dynamic> users = response.data['users'];
    if (users.contains(int.parse(dni))) {
      child = const Text(
        'Marcar salida',
        style: TextStyle(color: Colors.white),
      );
      color = Colors.green;
      ingreso = false;
      notifyListeners();
    } else {
      child = const Text(
        'Marcar entrada',
        style: TextStyle(color: Colors.white),
      );
      color = Colors.red;
      notifyListeners();
    }
  }

  Future<Response<dynamic>?> queryStatus() async {
    Response<dynamic>? response;
    try {
      response = await Dio().get('${apiBase}users/status/');
    } catch (e) {
      print(e);
    }
    return response;
  }
}
