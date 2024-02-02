import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/personal/personal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PersonalProvider(),
      child: Consumer<PersonalProvider>(builder: (context, provider, child) {
        return MyScaffold(
          title: 'Oficina de Personal',
          drawer: true,
          section: DrawerSection.personal,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('FECHA: ${provider.nowDate}   08:30hrs')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      width: max(1000, widthDevice - 40),
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
                                    offset: const Offset(0, 3))
                              ],
                            ),
                            child: Row(
                                children: List.generate(
                                    provider.summaryLabels.length * 2 - 1,
                                    (index) {
                              if (index.isOdd) {
                                return const SizedBox(
                                  width: 10,
                                );
                              } else {
                                final i = index ~/ 2;
                                return Expanded(
                                  child: Text(
                                    '${provider.summaryLabels[i]}\n(${provider.dailyPart[i]?.length ?? 0})',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                );
                              }
                            })),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
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
                              child: Row(
                                  children: List.generate(
                                      provider.summaryLabels.length * 2 - 1,
                                      (index) {
                                if (index.isOdd) {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      width: 2,
                                    ),
                                  );
                                } else {
                                  final i = index ~/ 2;
                                  return Expanded(
                                    child: ListView(
                                      children: List.generate(
                                          provider.dailyPart[i]?.length ?? 0,
                                          (index) {
                                        final item =
                                            provider.dailyPart[i]![index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15.0),
                                          child: Text(
                                            item['FULLNAME'] ?? '-',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                              })),
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
                      onPressed: provider.onTapExport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101139),
                      ),
                      child: const Text('Generar Parte'),
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
