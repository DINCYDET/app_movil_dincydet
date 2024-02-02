import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/api/api_inventory.dart';
import 'package:app_movil_dincydet/api/projects/api_projects.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_detail.dart';
import 'package:app_movil_dincydet/previews/qr_assistance.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/qrcodes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class PreviewCameraQR extends StatefulWidget {
  const PreviewCameraQR({super.key});

  @override
  State<PreviewCameraQR> createState() => _PreviewCameraQRState();
}

class _PreviewCameraQRState extends State<PreviewCameraQR> {
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
      title: 'Lector QR Usuario-Inventario',
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
            ),
          ],
        ),
      ),
    );
  }

  void qrReading(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      cameraQRcontroller.stop();

      setState(() {
        textQR = barcode.rawValue;
      });
      //FILTRAR QRS

      try {
        final code = qrDecode(barcode.rawValue!);
        print(code);
        final category = code.split('-')[1];
        final id = int.tryParse(code.split('-')[2]);
        int? index;

        //action for inventory
        if (category == 'INV') {
          textQR = 'inventario detectado';
          await getProjectsList();
          await getInventory();
          index = inventoryData.indexWhere((element) => element['ID'] == id);
          if (index == -1) {
            textQR = 'Inventario no encontrado';
            await showCustomAlert(textQR);
            return;
          }

          await onTapInventoryDetail(index);

          //Action for user
        } else if (category == 'USR') {
          textQR = 'usuario detectado : $code';
          await getUsers();
          index = users.indexWhere((element) => element['DNI'] == id);
          if (index == -1) {
            textQR = 'Usuario no encontrado';
            await showCustomAlert(textQR);
            return;
          }
          await onTapViewUser(index);

          //Action for ubication
        } else if (category == 'GIS') {
          textQR = 'ubicacion detectada';
          if (id == null) {
            textQR = 'ubicacion no encontrada';
            await showCustomAlert(textQR);
            return;
          }
          final results = await apiSetPosition(id);
          if (results == null) {
            textQR = 'Ocurrió un error al establecer la posicion';
            await showCustomAlert(textQR);
            return;
          }
          Navigator.of(navigatorKey.currentContext!).pop();

          //action defect
        } else {
          textQR = 'QR no válido.';
          await showCustomAlert(textQR);
        }
      } catch (e) {
        textQR = 'Error al leer el código';
        await showCustomAlert(textQR);

        print(e);
      }
      cameraQRcontroller.start();
      return;
    }
  }

  Future<void> getUsers() async {
    List<Map<String, dynamic>>? data = await apiUsersGetAllDetailed();
    if (data == null) {
      return;
    }
    users = data;
  }

  List<dynamic> users = [];

  Future<void> onTapViewUser(int index) async {
    final data = users[index];
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERID = data['DNI'];
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = data;
    await Navigator.pushNamed(navigatorKey.currentContext!, '/userviewpage');
  }

  List<Map<String, dynamic>> projectsList = [
    {
      "NAME": "DINCYDET",
      "ID": -1,
    }
  ];
  List<Map<String, dynamic>> inventoryData = [];

  getProjectsList() async {
    final projects = await apiProjectsGetList();
    if (projects != null) {
      projectsList.addAll(projects);
    }
  }

  getInventory() async {
    final results = await apiInventoryGetAll(
      startDate: null,
      endDate: null,
      origin: null,
      project: null,
      location: null,
      itemType: null,
      ibp: null,
    );

    if (results == null) return;
    inventoryData = results;
  }

  Future<void> onTapInventoryDetail(int index) async {
    await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return InventoryDetailDialog(
            projectsList: projectsList,
            data: inventoryData[index],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraQRcontroller.dispose();
  }
}
