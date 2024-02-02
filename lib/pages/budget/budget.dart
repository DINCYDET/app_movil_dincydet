import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/budget/budget_tables.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/budget/budget_provider.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Lista de Presupuesto',
      drawer: true,
      section: DrawerSection.budget,
      body: ChangeNotifierProvider(
        create: (context) => BudgetProvider(),
        child: Consumer<BudgetProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    label: Text('Estado'),
                                    border: OutlineInputBorder(),
                                  ),
                                  value: provider.statusValue,
                                  items: List.generate(
                                      provider.statusList.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(provider.statusList[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedStatus,
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
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: max(700, widthDevice - 40),
                        child: BudgetTable(
                          data: provider.budgetData,
                          onTapAccept: provider.onTapAccept,
                          onTapReject: provider.onTapReject,
                          onTapDetails: provider.onTapDetails,
                          onRefresh: provider.onTapSearch,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: provider.onTapExport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF0077B6),
                        ),
                        icon: const Icon(
                          Icons.save_alt,
                          color: Colors.white,
                        ),
                        label: const Text('Generar Reporte'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
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
                        label: const Text('Presupuesto'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
