import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/manage_docs/doc_received_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class DocumentReceivedPage extends StatelessWidget {
  const DocumentReceivedPage({super.key});
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
      create: (context) => DocumentReceivedProvider(),
      child: Consumer<DocumentReceivedProvider>(
        builder: (context, provider, child) {
          return MyScaffold(
            title: 'Documentos Recibidos',
            section: DrawerSection.docsreceived,
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
                          height: 10,
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
                          height: 10,
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
                              width: 10,
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
                                      'Fecha de registro',
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
                                      'Fecha documento',
                                      style: headerStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Promotor',
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
                                infoText: '',
                                onRefresh: provider.onTapSearch,
                                itemBuilder: (context, i) {
                                  final item = provider.documents[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 5.0,
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isoToLocalDate(
                                                    item['CREATEDAT']),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: rowStyle,
                                              ),
                                              Text(
                                                isoToLocalTime(
                                                    item['CREATEDAT']),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: rowStyle.copyWith(
                                                  color:
                                                      const Color(0xFF0096C7),
                                                ),
                                              ),
                                            ],
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
                                            isoToLocalDate(item['DATE']),
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            dependencies[
                                                item['DESTINATION'] ?? 0],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['ISSUE'].toString(),
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Visibility(
                                                visible: provider.isUserAllowed,
                                                child: InkWell(
                                                  onTap: () =>
                                                      provider.onTapEdit(i),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Color(0xFF073264),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: provider.isUserAllowed,
                                                child: InkWell(
                                                  onTap: () =>
                                                      provider.onTapDelete(i),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: provider.onTapAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D154A),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar documento'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
