import 'dart:io';

import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserField extends StatelessWidget {
  const UserField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.readOnly = false,
    this.enabled = true,
    this.isPass = false,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final bool enabled;
  final bool isPass;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: isPass,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        label: Text(
          label,
        ),
        icon: Icon(
          icon,
          size: 36,
          color: MC_darkblue,
        ),
      ),
    );
  }
}

class MyDropdown extends StatelessWidget {
  const MyDropdown({
    super.key,
    required this.dropdownprovider,
    required this.label,
    required this.icon,
  });

  final MyDropdownProvider dropdownprovider;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => dropdownprovider,
      child: Consumer<MyDropdownProvider>(
        builder: (context, provider, child) {
          return InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              icon: Icon(
                icon,
                size: 36,
                color: MC_darkblue,
              ),
              label: Text(label),
              border: const OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: provider._value,
                isExpanded: true,
                isDense: true,
                items: provider.items.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  provider.onChanged(value!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDropdownProvider extends ChangeNotifier {
  MyDropdownProvider({required this.items});
  final List<String> items;

  String? _value;
  void onChanged(String value) {
    _value = value;
    notifyListeners();
  }

  String? get value {
    return _value;
  }

  set value(String? value) {
    _value = value;
    notifyListeners();
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key, required this.onTap});
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              shape: const CircleBorder(),
              fixedSize: const Size(40, 40),
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
            ),
            child: const Icon(
              Icons.add,
              size: 36,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Registrar',
            style: TextStyle(
                fontSize: 28,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class UpdatePhoto extends StatelessWidget {
  const UpdatePhoto({super.key, required this.updatephotoprovider});
  final UpdatePhotoProvider updatephotoprovider;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => updatephotoprovider,
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer<UpdatePhotoProvider>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () {
                provider.onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                ),
                child: Center(
                  child: provider.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UpdatePhotoProvider extends ChangeNotifier {
  bool updated = false;
  File? file;
  Widget child = const Text(
    'Seleccionar imagen',
    style: TextStyle(color: Colors.grey),
  );
  String? imgpath;
  void onTap() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      file = File(result.files.single.path!);
      child = Image.file(
        file!,
        fit: BoxFit.contain,
      );
      imgpath = result.files.single.path!;
      notifyListeners();
    } else {
      // User canceled the picker
    }
  }
}
