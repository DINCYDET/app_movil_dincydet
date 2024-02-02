import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/documents/documents_tables.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/documents/documents_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DocumentsProvider(),
        child: Consumer<DocumentsProvider>(
          builder: (context, provider, child) {
            return MyScaffold(
              title: 'Lista de papeletas',
              drawer: true,
              section: DrawerSection.documents,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filtros de Búsqueda',
                          style: TextStyle(
                            color: Color(0xFF0096C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    label: Text('Estado'),
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  items: List.generate(provider.stages.length,
                                      (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(provider.stages[index]),
                                    );
                                  }),
                                  value: provider.stageValue,
                                  onChanged: provider.onChangedStage,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: MyTextField(
                                  label: 'Fecha Inicio',
                                  readOnly: true,
                                  onTap: provider.onTapStartDate,
                                  prefix: const Icon(Icons.calendar_today),
                                  controller: provider.startDateController,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: MyTextField(
                                  label: 'Fecha Fin',
                                  readOnly: true,
                                  onTap: provider.onTapEndDate,
                                  prefix: const Icon(Icons.calendar_today),
                                  controller: provider.endDateController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: provider.onTapSearch,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF6251A2),
                              ),
                              icon: const Icon(Icons.search),
                              label: const Text('Buscar'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: provider.onTapClean,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFB3261E),
                              ),
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Limpiar'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: max(1100, widthDevice - 40),
                        child: DocumentsTable(
                          data: provider.documents,
                          onTapDetail: provider.onTapDetail,
                          onTapAuth: provider.onTapAuth,
                          isIn: !provider.send,
                          myUserDNI: provider.myUserDNI,
                          onRefresh: provider.onTapSearch,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: provider.onTapAdd,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF101139),
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text('Papeleta'),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton.icon(
                        onPressed: provider.onTapSended,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xB20096C7),
                        ),
                        icon: Icon(
                          Icons.circle,
                          size: 32,
                          color: provider.send
                              ? const Color(0xFF2B9D0F)
                              : const Color(0xFFB3261E),
                        ),
                        label: Text(provider.send ? 'Enviado' : 'Recibido'),
                      ),
                    ],
                  )
                ]),
              ),
            );
          },
        ));
  }
}
