import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/src/utils/qrcodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRAssistance extends StatefulWidget {
  const QRAssistance({super.key});

  @override
  State<QRAssistance> createState() => _QRAssistanceState();
}

class _QRAssistanceState extends State<QRAssistance> {
  String? textQR = '';

  MobileScannerController cameraQRcontroller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    // facing: CameraFacing.front,
    // torchEnabled: true,
  );

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      drawer: false,
      title: 'Lector QR Asistencia',
      section: DrawerSection.other,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 700,
                child: MobileScanner(
                  // fit: BoxFit.contain,
                  controller: cameraQRcontroller,
                  onDetect: (capture) async {
                    qrReading(capture);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void qrReading(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}|');
      cameraQRcontroller.stop();

      setState(() {
        textQR = barcode.rawValue;
      });

      try {
        // print('+++++++++++++++++ ${encrypter.encrypt()}')
        var code = qrDecode(barcode.rawValue!);
        // var code = barcode.rawValue;
        if (code == 'DINCYDET-GEN-ASSISTANCE') {
          Navigator.pop(context, true);
          return;
        } else {
          textQR = 'QR no válido para asistencia';
          await showCustomAlert(textQR);
        }
      } catch (e) {
        textQR = 'error al leer el código';
        await showCustomAlert(textQR);

        print(e);
      }
      cameraQRcontroller.start();
      return;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraQRcontroller.dispose();
  }
}

Future<void> showCustomAlert(String? label) async {
  await showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(10),
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'Aviso!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF073264),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
        children: [
          Text(
            label ?? 'Error',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey.shade200,
                    backgroundColor: const Color(0xFF073264),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar')),
            ],
          )
        ],
      );
    },
  );
}
