import 'package:flutter/cupertino.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoAlertDialog(
      title: Text('Cargando...'),
      content: CupertinoActivityIndicator(),
    );
  }
}
