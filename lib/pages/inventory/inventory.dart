import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_charts.dart';
import 'package:app_movil_dincydet/pages/inventory/inventory_tables.dart';
import 'package:app_movil_dincydet/providers/inventory/inventory_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:searchfield/searchfield.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => InventoryProvider(),
        child: MyScaffold(
          title: 'Lista de Bienes',
          drawer: true,
          section: DrawerSection.inventory,
          body: Consumer<InventoryProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: provider.isList,
                      child: Container(
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
                                    child: MyTextField(
                                      label: 'IBP',
                                      controller: provider.ibpController,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: SearchField<int>(
                                      searchInputDecoration:
                                          const InputDecoration(
                                        labelText: 'Tipo de bien',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: provider.itemTypeController,
                                      suggestions: List.generate(
                                        inventoryTypes.length,
                                        (index) {
                                          return SearchFieldListItem(
                                            inventoryTypes[index],
                                            item: index,
                                          );
                                        },
                                      ),
                                      onSuggestionTap: provider.onTapType,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
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
                                      prefix: const Icon(Icons.calendar_today),
                                      controller: provider.startDateController,
                                      onTap: provider.onTapStartDate,
                                    ),
                                  ),
                                ],
                              ),
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
                                    child: SearchField<int>(
                                      searchInputDecoration:
                                          const InputDecoration(
                                        labelText: 'Proyecto',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: provider.projectController,
                                      suggestions: List.generate(
                                          provider.projectOnlyList.length,
                                          (index) {
                                        return SearchFieldListItem(
                                          provider.projectOnlyList[index]
                                              ['NAME'],
                                          item: provider.projectOnlyList[index]
                                              ['ID'],
                                        );
                                      }),
                                      onSuggestionTap:
                                          provider.onTapProjectOnly,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Ubicación',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      items: List.generate(areasDincydet.length,
                                          (index) {
                                        return DropdownMenuItem(
                                          value: index,
                                          child: Text(areasDincydet[index]),
                                        );
                                      }),
                                      onChanged: provider.onChangedLocation,
                                      isExpanded: true,
                                      isDense: true,
                                      value: provider.locationValue,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: SearchField<int>(
                                      searchInputDecoration:
                                          const InputDecoration(
                                        labelText: 'Origen de Adquisición',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: provider.originController,
                                      suggestions: List.generate(
                                          provider.projectsList.length,
                                          (index) {
                                        return SearchFieldListItem(
                                          provider.projectsList[index]['NAME'],
                                          item: provider.projectsList[index]
                                              ['ID'],
                                        );
                                      }),
                                      onSuggestionTap: provider.onTapProject,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
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
                                      prefix: const Icon(Icons.calendar_today),
                                      controller: provider.endDateController,
                                      onTap: provider.onTapEndDate,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !provider.isList,
                      child: Container(
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
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: SearchField<int>(
                                      searchInputDecoration:
                                          const InputDecoration(
                                        labelText: 'Origen de Adquisición',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: provider.originController,
                                      suggestions: List.generate(
                                          provider.projectsList.length,
                                          (index) {
                                        return SearchFieldListItem(
                                          provider.projectsList[index]['NAME'],
                                          item: provider.projectsList[index]
                                              ['ID'],
                                        );
                                      }),
                                      onSuggestionTap: provider.onTapProject,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Ubicación',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      items: List.generate(areasDincydet.length,
                                          (index) {
                                        return DropdownMenuItem(
                                          value: index,
                                          child: Text(areasDincydet[index]),
                                        );
                                      }),
                                      onChanged: provider.onChangedLocation,
                                      isExpanded: true,
                                      isDense: true,
                                      value: provider.locationValue,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: SearchField<int>(
                                      searchInputDecoration:
                                          const InputDecoration(
                                        labelText: 'Tipo de bien',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: provider.itemTypeController,
                                      suggestions: List.generate(
                                        inventoryTypes.length,
                                        (index) {
                                          return SearchFieldListItem(
                                            inventoryTypes[index],
                                            item: index,
                                          );
                                        },
                                      ),
                                      onSuggestionTap: provider.onTapType,
                                      suggestionAction:
                                          SuggestionAction.unfocus,
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
                                SizedBox(
                                  child: ElevatedButton.icon(
                                    onPressed: provider.onTapPlot,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFF6251A2),
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Gráfico'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  child: ElevatedButton.icon(
                                    onPressed: provider.onTapCleanPlot,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFFB3261E),
                                    ),
                                    icon: const Icon(Icons.delete_forever),
                                    label: const Text('Limpiar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: provider.isList,
                      child: Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: max(900, widthDevice - 40),
                            child: InventoryTable(
                              data: provider.inventoryData,
                              onTapDelete: provider.onTapDelete,
                              onTapEdit: provider.onTapEdit,
                              onTapDetail: provider.onTapDetail,
                              onRefresh: provider.onTapSearch,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !provider.isList,
                      child: Expanded(
                        child: Screenshot(
                          controller: provider.screenshotController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: provider.originData != null
                                      ? InventoryChart(
                                          label: 'Origen de adquisición',
                                          data: provider.originData!,
                                        )
                                      : const Center(
                                          child: Text(
                                              'Seleccione un origen de adquisición'),
                                        ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 400,
                                  child: provider.locationData != null
                                      ? InventoryChart(
                                          label: 'Ubicación',
                                          data: provider.locationData!,
                                        )
                                      : const Center(
                                          child:
                                              Text('Seleccione una ubicación'),
                                        ),
                                ),
                              ],
                            ),
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
                        Visibility(
                          visible: !provider.isList,
                          child: ElevatedButton(
                            onPressed: provider.onTapExport,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF101139),
                            ),
                            child: const Text('Exportar'),
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: provider.isList,
                          child: ElevatedButton.icon(
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
                            label: const Text('Bien'),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        ElevatedButton.icon(
                          onPressed: provider.onTapChange,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF0077B6),
                          ),
                          icon: Icon(
                            Icons.circle,
                            size: 32,
                            color: provider.isList
                                ? const Color(0xFFBB271A)
                                : const Color(0xFF2B9D0F),
                          ),
                          label: Text(provider.isList
                              ? 'Lista de Bienes'
                              : 'Reporte General'),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
