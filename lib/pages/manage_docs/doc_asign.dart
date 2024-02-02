import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/manage_docs/doc_asign_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class DocumentAssignPage extends StatelessWidget {
  const DocumentAssignPage({super.key});
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  final TextStyle rowStyle = const TextStyle(
    color: Color(0xFF535E78),
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentAssignProvider(),
      child: Consumer<DocumentAssignProvider>(
        builder: (context, provider, child) {
          return MyScaffold(
            title: 'Documentos Asignados',
            section: DrawerSection.docsassigned,
            drawer: true,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        )
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
                              fontSize: 20),
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
                                child: MyTextField(
                                  controller: provider.startDateController,
                                  label: 'Fecha Inicio',
                                  readOnly: true,
                                  prefix: const Icon(Icons.calendar_today),
                                  onTap: provider.onTapStartDate,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: MyTextField(
                                  controller: provider.endDateController,
                                  label: 'Fecha Fin',
                                  readOnly: true,
                                  prefix: const Icon(Icons.calendar_today),
                                  onTap: provider.onTapEndDate,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // Picker for document type
                              SizedBox(
                                width: 200,
                                child: DropdownButtonFormField<int>(
                                  value: provider.documentType,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de documento',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  items: List.generate(
                                      documentManagementTypes.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child:
                                          Text(documentManagementTypes[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangeDocType,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: SearchField<int>(
                                  controller: provider.promoterController,
                                  suggestions: List.generate(
                                    dependencies.length,
                                    (index) {
                                      return SearchFieldListItem(
                                        dependencies[index],
                                        item: index,
                                      );
                                    },
                                  ),
                                  searchInputDecoration: const InputDecoration(
                                    label: Text('Destino'),
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onSuggestionTap: provider.onTapDependencie,
                                  suggestionAction: SuggestionAction.unfocus,
                                ),
                              ),

                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: MyTextField(
                                  label: 'Nº de documento',
                                  controller: provider.documentController,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: MyTextField(
                                  label: 'Asunto',
                                  controller: provider.topicController,
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
                                backgroundColor: const Color(0xFFB3261E),
                              ),
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Limpiar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: max(700, widthDevice - 40),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF535E78),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      'Nº',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Tipo de documento',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Nº documento',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Asunto',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Decreto',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Plazo de respuesta',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Detalle',
                                      style: headerStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: PaginatedWidget(
                                itemsPerPage: 12,
                                itemCount: provider.documents.length,
                                onRefresh: provider.onTapSearch,
                                infoText: '',
                                itemBuilder: (context, i) {
                                  final item = provider.documents[i];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xFFB3261E),
                                                shape: BoxShape.circle),
                                            padding: const EdgeInsets.all(4.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${i + 1}',
                                              style: rowStyle.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            documentManagementTypes[
                                                item['DOCUMENTTYPE'] ?? 0],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['DOCUMENT'] ?? 'Sin documento',
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['ISSUE'],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['DECRET'],
                                            style: rowStyle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${isoToLocalDate(item['ACTIONDATE'])} ${item['ACTIONHOUR']}',
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    provider.onTapView(i),
                                                child: const Icon(
                                                  Icons.info,
                                                  color: Color(0xFF073264),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // SizedBox(
                            //   height: 40,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     ElevatedButton.icon(
                            //       onPressed: provider.onTapAdd,
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: Color(0xFF1D154A),
                            //         padding: EdgeInsets.symmetric(
                            //           vertical: 15.0,
                            //           horizontal: 20.0,
                            //         ),
                            //       ),
                            //       icon: Icon(Icons.add),
                            //       label: Text('Documento'),
                            //     ),
                            //   ],
                            // )
                          ],
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
                        onPressed: provider.onTapType,
                        icon: Icon(
                          Icons.circle,
                          color: provider.typeColor,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xB20096C7),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        label: Text(provider.typeText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
