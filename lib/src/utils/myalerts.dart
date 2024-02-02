import 'package:app_movil_dincydet/src/utils/userinfo.dart';
import 'package:flutter/material.dart';

class MyInfoAlert extends StatelessWidget {
  const MyInfoAlert({
    super.key,
    required this.leading,
    required this.label,
    required this.status,
    required this.args,
    this.controller,
  });
  final Widget leading;
  final String label;
  final int? status;
  final UserArguments args;
  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: status == 0
          ? [
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading,
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ]
          : [
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading,
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.grey),
                  ),
                  onPressed: () {
                    if (status == 1) {
                      Navigator.pop(context);
                      if (controller != null) {
                        controller!.resumeCamera();
                      }
                    } else {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home',
                          arguments: args);
                    }
                  },
                  child: status == 1
                      ? const Text(
                          'Reintentar',
                          style: TextStyle(color: Colors.black),
                        )
                      : const Text(
                          'Finalizar',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              )
            ],
    );
  }
}
