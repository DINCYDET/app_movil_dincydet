import 'package:flutter/cupertino.dart';

class IncorrectPasswordDialog extends StatelessWidget {
  const IncorrectPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Contraseña Incorrecta'),
      content: const Text('La contraseña que ingresaste es incorrecta.'),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class UserNotExistsDialog extends StatelessWidget {
  const UserNotExistsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('El usuario no existe'),
      content: const Text('El usuario que ingresaste no existe.'),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
