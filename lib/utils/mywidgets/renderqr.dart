import 'dart:convert';
import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';

class QrImage extends StatefulWidget {
  const QrImage({
    super.key,
    required this.data,
    this.title = '',
    this.subtitle = '',
  });
  final String data;
  final String title;
  final String subtitle;
  @override
  State<QrImage> createState() => _QrImageState();
}

class _QrImageState extends State<QrImage> {
  @override
  Widget build(BuildContext context) {
    final Size limits = MediaQuery.of(context).size;
    final qr =
        Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium);
    final qrstring =
        qr.toSvg(widget.data, width: limits.width, height: limits.height);

    return AspectRatio(
      aspectRatio: 1.0,
      child: FutureBuilder(
        future: genQR(qrstring),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SvgPicture.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: const Icon(Icons.download),
                    ),
                    onTap: () => onTapExport(qrstring),
                  ),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Uint8List> genQR(String qrstring) async {
    //final output = await getTemporaryDirectory();
    //final file = File("${output.path}/qr.svg");
    //await file.writeAsString(qrstring);
    //return file.readAsBytes();
    return utf8.encode(qrstring);
  }

  void onTapExport(String qrString) async {
    final String? pickedPath = await FilePicker.platform.getDirectoryPath();
    if (pickedPath == null) return;
    ScreenshotController screenshotController = ScreenshotController();
    final qr =
        Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium);
    final qrstring = qr.toSvg(widget.data, width: 340, height: 340);
    final qrData = await genQR(qrstring);
    final imageData = await screenshotController.captureFromWidget(
      SizedBox(
        width: 800,
        height: 400,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: 340,
                child: Column(
                  children: [
                    SvgPicture.memory(
                      qrData,
                      width: 340,
                      height: 340,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    File file = File('$pickedPath/QRCode_${widget.subtitle}.jpg');
    await file.writeAsBytes(imageData);
  }
}
