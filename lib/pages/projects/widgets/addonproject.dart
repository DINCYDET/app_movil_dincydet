import 'package:app_movil_dincydet/pages/projects/widgets/tasks.dart';
import 'package:app_movil_dincydet/providers/projects/addonproject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddonProjectWidget extends StatelessWidget {
  const AddonProjectWidget({super.key, required this.addonprovider});
  final AddonProjectProvider addonprovider;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ChangeNotifierProvider(
          create: (context) => addonprovider,
          child: Consumer<AddonProjectProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Desarrollo',
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF7E0F08),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF7E0F08),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children:
                                  List.generate(provider.tasks.length, (i) {
                                return TaskWidget(
                                    data: provider.tasks[i], i: i);
                              }),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                provider.addTask();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Tarea'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
