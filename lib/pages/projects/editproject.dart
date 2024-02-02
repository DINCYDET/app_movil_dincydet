import 'package:app_movil_dincydet/providers/projects/editproject_provider.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/addonproject.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProject extends StatelessWidget {
  const EditProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      drawer: false,
      section: DrawerSection.other,
      title: 'Editar proyecto',
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ChangeNotifierProvider<EditProjectProvider>(
          create: (context) => EditProjectProvider(),
          child: Consumer<EditProjectProvider>(
              builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AddonProjectWidget(
                    addonprovider: provider.addonprovider,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Consumer<EditProjectProvider>(
                      builder: (context, provider, child) {
                        return TextButton(
                          onPressed: provider.onTapRegister,
                          style: TextButton.styleFrom(
                              backgroundColor: MC_darkblue,
                              foregroundColor: Colors.white),
                          child: const Text('Registrar'),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
