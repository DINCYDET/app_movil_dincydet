import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:flutter/material.dart';

class Previewimg extends StatelessWidget {
  const Previewimg({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Vista previa',
      drawer: false,
      section: DrawerSection.other,
      body: Center(
        child: Image.network(
          //'${apiBase}uploads/tickets/$imgurl',
          "imgurl", //TODO: Complete this
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
