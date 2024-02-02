import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/budget/budgetnew_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class BudgetNewPage extends StatelessWidget {
  const BudgetNewPage({super.key});

  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  final TextStyle rowStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BudgetNewProvider(),
      child: Consumer<BudgetNewProvider>(builder: (context, provider, child) {
        return MyScaffold(
          title: 'Presupuesto',
          drawer: false,
          section: DrawerSection.other,
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
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: SearchField<String>(
                                suggestions: List.generate(
                                  provider.ps1Suggestions.length,
                                  (index) {
                                    final key = provider.ps1Suggestions.keys
                                        .elementAt(index);
                                    final value = provider.ps1Suggestions[key];
                                    final text =
                                        "${provider.ps0Key}.$key ${value["name"]}";
                                    return SearchFieldListItem(
                                      text,
                                      item: key,
                                    );
                                  },
                                ),
                                controller: provider.namePS1Controller,
                                onSuggestionTap: provider.onTapPS1Key,
                                suggestionAction: SuggestionAction.unfocus,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Nombre P. Subgenérica 1'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: SearchField<String>(
                                suggestions: List.generate(
                                  provider.pSubESuggestions.length,
                                  (index) {
                                    final key = provider.pSubESuggestions.keys
                                        .elementAt(index);
                                    final value =
                                        provider.pSubESuggestions[key];
                                    String prefix =
                                        "${provider.ps0Key}.${provider.ps1Key}.${provider.ps2Key}.${provider.pe1Key}.${provider.pe2Key}";
                                    prefix = '$prefix.';
                                    if ((key as String).contains('.')) {
                                      prefix = '';
                                    }
                                    final text = "$prefix$key ${value["name"]}";
                                    return SearchFieldListItem(
                                      text,
                                      item: key,
                                    );
                                  },
                                ),
                                suggestionAction: SuggestionAction.unfocus,
                                onSuggestionTap: provider.onTapPSubEKey,
                                controller: provider.namePSubEController,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Nombre P. Sub-específica'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Adjuntar archivo',
                                ),
                                child: InkWell(
                                    onTap: provider.onTapAddFile,
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size: 24,
                                      color: provider.pickedFile != null
                                          ? Colors.green
                                          : MC_darkblue,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: SearchField<String>(
                                suggestions: List.generate(
                                  provider.ps2Suggestions.length,
                                  (index) {
                                    final key = provider.ps2Suggestions.keys
                                        .elementAt(index);
                                    final value = provider.ps2Suggestions[key];
                                    final prefix =
                                        "${provider.ps0Key}.${provider.ps1Key}";
                                    final text =
                                        "$prefix.$key ${value["name"]}";
                                    return SearchFieldListItem(
                                      text,
                                      item: key,
                                    );
                                  },
                                ),
                                suggestionAction: SuggestionAction.unfocus,
                                onSuggestionTap: provider.onTapPS2Key,
                                controller: provider.namePS2Controller,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Nombre P. Subgenérica 2'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: MyTextField(
                                label: 'Descripción',
                                controller: provider.descriptionController,
                              ),
                            ),
                          ],
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
                              child: MyTextField(
                                label: 'Importe',
                                controller: provider.amountController,
                                inputFormatters: [
                                  // Allow numbers with 2 decimal places
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: SearchField<String>(
                                suggestions: List.generate(
                                  provider.pe1Suggestions.length,
                                  (index) {
                                    final key = provider.pe1Suggestions.keys
                                        .elementAt(index);
                                    final value = provider.pe1Suggestions[key];
                                    final prefix =
                                        "${provider.ps0Key}.${provider.ps1Key}.${provider.ps2Key}";
                                    final text =
                                        "$prefix.$key ${value["name"]}";
                                    return SearchFieldListItem(
                                      text,
                                      item: key,
                                    );
                                  },
                                ),
                                suggestionAction: SuggestionAction.unfocus,
                                onSuggestionTap: provider.onTapPE1Key,
                                controller: provider.namePE1Controller,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Nombre P. Específica 1'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: MyTextField(
                                label: 'Detalle',
                                controller: provider.detailController,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: SearchField<int>(
                                suggestions: List.generate(
                                  provider.projectsList.length,
                                  (index) {
                                    final item = provider.projectsList[index];
                                    final name = item["NAME"];
                                    final prjid = item["ID"];
                                    return SearchFieldListItem(
                                      name,
                                      item: prjid,
                                    );
                                  },
                                ),
                                suggestionAction: SuggestionAction.unfocus,
                                onSuggestionTap: provider.onTapProjectKey,
                                controller: provider.fromController,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Solicitante'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: SearchField<String>(
                                suggestions: List.generate(
                                  provider.pe2Suggestions.length,
                                  (index) {
                                    final key = provider.pe2Suggestions.keys
                                        .elementAt(index);
                                    final value = provider.pe2Suggestions[key];
                                    final prefix =
                                        "${provider.ps0Key}.${provider.ps1Key}.${provider.ps2Key}.${provider.pe1Key}";
                                    final text =
                                        "$prefix.$key ${value["name"]}";
                                    return SearchFieldListItem(
                                      text,
                                      item: key,
                                    );
                                  },
                                ),
                                suggestionAction: SuggestionAction.unfocus,
                                onSuggestionTap: provider.onTapPE2Key,
                                controller: provider.namePE2Controller,
                                searchInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  label: Text('Nombre P. Específica 2'),
                                ),
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
                            onPressed: provider.onTapAdd,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF6251A2),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar'),
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
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Color(0xFF0096C7),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'RESUMEN PRESUPUESTO SOLICITADO',
                      style: TextStyle(
                        color: Color(0xFF0096C7),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 700,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
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
                                    'N°',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Solicitante',
                                    style: headerStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    'Partida',
                                    style: headerStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Descripción',
                                    style: headerStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    'Importe',
                                    style: headerStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    'Acción',
                                    textAlign: TextAlign.center,
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
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                              child: ListView(
                                children: List.generate(
                                    provider.budgetData.length, (index) {
                                  final item = provider.budgetData[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFB3261E),
                                            ),
                                            padding: const EdgeInsets.all(4.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            item['FROM'],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['DEPARTURE'],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            item['DESCRIPTION'],
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${item['AMOUNT']} PEN',
                                            style: rowStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () =>
                                                provider.onTapRemoveItem(index),
                                            child: const Icon(
                                              Icons.remove_circle,
                                              color: Color(0xFFBB271A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
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
                    ElevatedButton(
                      onPressed: provider.onTapRequest,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF101139),
                      ),
                      child: const Text('Solicitar presupuesto'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: provider.onTapCancel,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF101139),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
