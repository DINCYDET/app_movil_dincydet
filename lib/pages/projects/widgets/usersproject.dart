import 'package:app_movil_dincydet/providers/projects/newproject_provider.dart';
import 'package:app_movil_dincydet/pages/projects/widgets/labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersProjectWidget extends StatelessWidget {
  const UsersProjectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Consumer<NewProjectProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const TextIconLabel(
                        label: 'Miembros del proyecto', number: 4),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: provider.onTapNewMember,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar miembro'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Column(
                    children: [],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
