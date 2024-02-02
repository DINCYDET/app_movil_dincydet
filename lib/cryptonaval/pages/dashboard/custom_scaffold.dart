import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/cryptonaval/providers/mainprovider.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primaryColor,
        middle: Text(
          title,
          style: const TextStyle(
            color: CupertinoColors.white,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTapList,
          child: const Icon(
            CupertinoIcons.list_dash,
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }

  void onTapList() async {
    // Show a menu with the following options:
    // - Cerrar Sesión
    // - Ajustes
    // - Cancelar
    final client = Provider.of<CryptoMainProvider>(navigatorKey.currentContext!,
            listen: false)
        .client;
    showCupertinoModalPopup(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Opciones'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                client.logout();
              },
              child: const Text('Cerrar Sesión'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                navigatorKey.currentState!.pushNamed('/settings');
              },
              child: const Text('Ajustes'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        );
      },
    );
  }
}
