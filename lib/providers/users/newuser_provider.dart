import 'package:app_movil_dincydet/api/user/api_users.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/users/useredit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class NewUserProvider extends ChangeNotifier {
  NewUserProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }
  // Controllers
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final dniController = TextEditingController();
  final cipController = TextEditingController();
  final passController = TextEditingController();

  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();

  final updatephotoprovider = UpdatePhotoProvider();

  int? gradeValue;
  int? areaValue;
  int? positionValue;
  int? userLaboralValue;
  int? userTemporalValue;
  int? bloodValue;

  DateTime? birthday;

  void onChangedGrade(int? value) {
    if (gradeValue == value) return;
    gradeValue = value;
    notifyListeners();
  }

  void onChangedArea(int? value) {
    if (areaValue == value) return;
    areaValue = value;
    notifyListeners();
  }

  void onChangedPosition(int? value) {
    if (positionValue == value) return;
    positionValue = value;
    notifyListeners();
  }

  void onChangedUserLaboral(int? value) {
    if (userLaboralValue == value) return;
    userLaboralValue = value;
    notifyListeners();
  }

  void onChangedUserTemporal(int? value) {
    if (userTemporalValue == value) return;
    userTemporalValue = value;
    notifyListeners();
  }

  void onChangedBlood(int? value) {
    if (bloodValue == value) return;
    bloodValue = value;
    notifyListeners();
  }

  Widget photowidget = const Text(
    'No se seleccion una imagen',
    style: TextStyle(color: Colors.grey),
  );

  // Validacion de campos

  bool validate(BuildContext context) {
    final imgpath = updatephotoprovider.imgpath;
    // Validaciones
    if (cipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete el CIP del usuario'),
        ),
      );
      return false;
    }
    if (positionValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione el cargo'),
        ),
      );
      return false;
    }
    if (areaValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione el area'),
        ),
      );
      return false;
    }
    if (gradeValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione el grado'),
        ),
      );
      return false;
    }
    if (bloodValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione el tipo de sangre'),
        ),
      );
      return false;
    }
    if (dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete la fecha de nacimiento'),
        ),
      );
      return false;
    }
    return true;
  }

  void onTapCreateUser() async {
    final imgpath = updatephotoprovider.imgpath;
    if (!validate(navigatorKey.currentContext!)) {
      return;
    }

    final dataMap = {
      'DNI': dniController.text,
      'CIP': cipController.text,
      'NAME': nameController.text,
      'LASTNAME': lastnameController.text,
      'USERPOSITION': positionValue,
      'DEPARTMENT': areaValue,
      'ADDRESS': addressController.text,
      'BLOOD': bloodValue,
      'GRADEID': gradeValue,
      'CONTACT': contactController.text,
      'EMAIL': emailController.text,
      'PHONE': phoneController.text,
      'PASS': passController.text,
      'BIRTHDAY': birthday?.toIso8601String(),
      'LABORAL_CONDITION': userLaboralValue,
      'TEMPORAL_CONDITION': userTemporalValue,
    };
    if (imgpath != null) {
      dataMap['files'] = [
        await MultipartFile.fromFile(
          imgpath,
          filename: basename(imgpath),
        )
      ];
    }
    Map<String, dynamic>? response = await apiUsersAdd(dataMap);
    if (response == null) {
      return;
    }
    Navigator.of(navigatorKey.currentContext!).pop(true);
  }

  void onTapDate() async {
    final date = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    birthday = date;
    dateController.text = DateFormat('dd-MM-yyyy').format(date);
    notifyListeners();
  }
}
