import 'package:app_movil_dincydet/api/api_updates.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ota_update/ota_update.dart';
import 'package:provider/provider.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  OtaEvent currentEvent = OtaEvent(OtaStatus.DOWNLOADING, '0%');

  @override
  void initState() {
    tryOtaUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: clampDouble(
                MediaQuery.of(context).size.width * 0.5,
                200,
                (MediaQuery.of(context).size.width - 80) * 0.8,
              ),
              child: Image.asset(
                'assets/logo_dincydet.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Estado de la actualización',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Estado OTA: ${currentEvent.status} : ${currentEvent.value} \n',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tryOtaUpdate() async {
    final token =
        Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
            .TOKEN;
    'No token';
    try {
      OtaUpdate()
          .execute(
        latestApkURI,
        headers: {
          'Authorization': "Bearer $token",
        },
        destinationFilename: 'dincydet.apk',
      )
          .listen((event) {
        setState(() {
          currentEvent = event;
        });
      });
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return const CupertinoAlertDialog(
            title: Text("Error"),
            content: Text(
                "No se pudo actualizar la aplicación\nReinicie la aplicación para volver a intentarlo"),
          );
        },
      );
    }
  }
}
