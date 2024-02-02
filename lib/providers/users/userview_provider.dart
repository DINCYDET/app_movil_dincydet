import 'dart:io';

import 'package:app_movil_dincydet/api/api_assistance.dart';
import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UserViewProvider extends ChangeNotifier {
  Map<String, dynamic>? USERDATA =
      Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
          .USERDATA;

  UserViewProvider(bool isMe) {
    if (isMe) {
      USERDATA =
          Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
              .USERDATA;
    }
    loadValues();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadAssistanceHistory();
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController cipController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  int? gradeValue;
  int? locationValue;
  int? positionValue;
  int? bloodValue;
  File? pickedIMG;

  int? userLaboralValue;
  int? userTemporalValue;

  NumberFormat formatter = NumberFormat("00000000");

  Map<String, dynamic> stats = {
    'stat0': 0,
    'stat1': 0,
    'stat2': 0,
    'stat3': 0,
  };
  void updateStatistics() async {
    // final dataMap = {'userid': userid};
    // Map<String, dynamic>? data = await apiAnalyticsById(dataMap);
    // if (data == null) {
    //   return;
    // }
    // stats['stat0'] = data['ticket-emit'];
    // stats['stat1'] = data['prj-complete'];
    // stats['stat2'] = data['ticket-pend'];
    // stats['stat3'] = data['prj-asigned'];
    // notifyListeners();
  }

  void loadValues() {
    if (USERDATA == null) return;
    nameController.text = USERDATA!['NAME'] ?? '';
    lastnameController.text = USERDATA!['LASTNAME'] ?? '';
    cipController.text = USERDATA!['CIP'] ?? '';
    addressController.text = USERDATA!['ADDRESS'] ?? '';
    phoneController.text = USERDATA!['PHONE'] ?? '';
    emailController.text = USERDATA!['EMAIL'] ?? '';
    bloodValue = USERDATA!['BLOOD'];
    gradeValue = USERDATA!['GRADEID'];
    locationValue = USERDATA!['DEPARTMENT'];
    positionValue = USERDATA!['USERPOSITION'];
    userLaboralValue = USERDATA!['LABORAL_CONDITION'];
    userTemporalValue = USERDATA!['TEMPORAL_CONDITION'];
    dniController.text = formatter.format(USERDATA!['DNI']);
  }

  void onChangeLaboralCondition(int? value) {
    if (userLaboralValue == value) return;
    userLaboralValue = value;
    notifyListeners();
  }

  void onChangeTemporalCondition(int? value) {
    if (userTemporalValue == value) return;
    userTemporalValue = value;
    notifyListeners();
  }

  void onChangeGrade(int? value) {
    if (gradeValue == value) return;
    gradeValue = value;
    notifyListeners();
  }

  void onChangePosition(int? value) {
    if (positionValue == value) return;
    positionValue = value;
    notifyListeners();
  }

  void onChangeLocation(int? value) {
    if (locationValue == value) return;
    locationValue = value;
    notifyListeners();
  }

  void onChangeBlood(int? value) {
    if (bloodValue == value) return;
    bloodValue = value;
    notifyListeners();
  }

  void onTapNewTicket() {
    navigatorKey.currentState!.pushReplacementNamed('/ticketsoutpage');
  }

  void onTapNewDocument() {
    navigatorKey.currentState!.pushReplacementNamed('/documentspage');
  }

  void onTapChat() {
    // Show an alert dialog that explains that the feature is under development
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.info,
      text: 'Esta función está en desarrollo',
      confirmBtnText: 'Ok',
      cancelBtnText: '',
      barrierDismissible: true,
      confirmBtnColor: Colors.blue,
      onCancelBtnTap: () {},
      onConfirmBtnTap: () => Navigator.of(navigatorKey.currentContext!).pop(),
    );
  }

  void onTapEditDNI() async {
    // Show an dialog to enter the new DNI
    TextEditingController newDNIController = TextEditingController();
    bool? complete = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar DNI'),
          content: TextField(
            controller: newDNIController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            decoration: const InputDecoration(
              labelText: 'Nuevo DNI',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
    if (complete != true) return;
    // Check if the DNI is valid
    if (newDNIController.text.length != 8) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('El DNI debe tener 8 dígitos'),
        ),
      );
    }
    // Update the DNI
    final result = await apiUsersChangeDNI(
      USERDATA?['DNI'],
      int.parse(newDNIController.text),
    );
    if (result == null) return;
    dniController.text = newDNIController.text;
  }

  void onTapEditPassword() async {
    TextEditingController newpassController = TextEditingController();
    TextEditingController newpassController2 = TextEditingController();
    // Show an dialog to enter the new password
    bool? complete = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newpassController,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                ),
                obscureText: true,
              ),
              TextField(
                controller: newpassController2,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
    if (complete != true) return;
    // Check if the passwords are the same
    if (newpassController.text != newpassController2.text) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
        ),
      );
    }
    if (newpassController.text.length < 6) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
        ),
      );
    }
    // Update the password
    apiUsersChangePassword(
      USERDATA?['DNI'],
      newpassController.text,
    );
  }

  void onTapSave() async {
    // Check if the fields are empty
    if (gradeValue == null ||
        locationValue == null ||
        positionValue == null ||
        bloodValue == null ||
        userLaboralValue == null ||
        userTemporalValue == null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos'),
        ),
      );
      return;
    }
    final dataMap = {
      'DNI': dniController.text,
      'CIP': cipController.text,
      'NAME': nameController.text,
      'LASTNAME': lastnameController.text,
      'USERPOSITION': positionValue,
      'DEPARTMENT': locationValue,
      'ADDRESS': addressController.text,
      'BLOOD': bloodValue,
      'GRADEID': gradeValue,
      'EMAIL': emailController.text,
      'PHONE': phoneController.text,
      'LABORAL_CONDITION': userLaboralValue,
      'TEMPORAL_CONDITION': userTemporalValue,
    };
    if (pickedIMG != null) {
      dataMap['files'] = await MultipartFile.fromFile(pickedIMG!.path);
    }
    final results = await apiUsersEdit(dataMap);
    if (results == null) return;
    if (results['success'] != true) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(results['message'] ?? 'Error desconocido'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      color: MC_darkblue,
                    ),
                  ),
                ),
              ],
            );
          });
      return;
    }
    // Show a success message
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Cambios guardados'),
      ),
    );
  }

  List<Map<String, dynamic>> assistanceHistory = [];
  void loadAssistanceHistory() async {
    final data = await apiAssistanceSummary(USERDATA?['DNI']);
    if (data == null) return;
    assistanceHistory = data;
    notifyListeners();
  }

  void onTapPickIMG() async {
    final results = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (results == null) return;
    pickedIMG = File(results.files.single.path!);
    notifyListeners();
  }
}
