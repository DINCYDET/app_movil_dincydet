import 'package:app_movil_dincydet/providers/projects/newproject_provider.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/baseproject.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class NewProjectPage extends StatelessWidget {
  const NewProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      drawer: false,
      section: DrawerSection.other,
      title: 'Nuevo proyecto',
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ChangeNotifierProvider<NewProjectProvider>(
          create: (context) => NewProjectProvider(),
          child: Consumer<NewProjectProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseProjectWidget(
                      basedata: provider.basedata,
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
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: MC_darkblue,
                          ),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        TextButton(
                          onPressed: provider.onTapRegister,
                          style: TextButton.styleFrom(
                            backgroundColor: MC_darkblue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Registrar'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
