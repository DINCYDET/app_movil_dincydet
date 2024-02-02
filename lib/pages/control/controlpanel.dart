import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/control/controlpanel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class ControlPanelPage extends StatelessWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Tablero de Control',
      section: DrawerSection.control,
      drawer: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ChangeNotifierProvider(
          create: (context) => ControlPanelProvider(),
          child: Consumer<ControlPanelProvider>(
              builder: (context, provider, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: max(1000, widthDevice - 40), //suma de padings:40
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF0077B6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Módulo Inventario',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Text(
                              'Módulo Presupuesto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Text(
                              'Oficina de Personal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Text(
                              'Módulo Gestión Documentaria',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(provider.user1.length, (k) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SearchField<int>(
                                            suggestionState: Suggestion.expand,
                                            suggestions: List.generate(
                                              provider.users.length,
                                              (index) {
                                                return SearchFieldListItem(
                                                    provider.users[index]
                                                            ['FULLNAME']
                                                        .toString(),
                                                    // item: key,
                                                    item: provider.users[index]
                                                        ['DNI'],
                                                    child: Text(provider
                                                        .users[index]
                                                            ['FULLNAME']
                                                        .toString()));
                                              },
                                            ),
                                            // initialValue: provider.user1[k] == null ||
                                            //         provider.users.isEmpty
                                            //     ? null
                                            //     : SearchFieldListItem(
                                            //         provider.users
                                            //             .firstWhere((element) =>
                                            //                 element['DNI'] ==
                                            //                 provider.user1[
                                            //                     k])['FULLNAME']
                                            //             .toString(),
                                            //         item: provider.users.firstWhere(
                                            //             (element) =>
                                            //                 element['DNI'] == provider.user1[k])['DNI'],
                                            //         child: Text(provider.users.firstWhere((element) => element['DNI'] == provider.user1[k])['FULLNAME'].toString())),
                                            enabled: provider.editable1[k],
                                            controller: provider.user1[k] ==
                                                        null ||
                                                    provider.users.isEmpty
                                                ? null
                                                : TextEditingController(
                                                    text: provider.users
                                                        .firstWhere(
                                                          (element) =>
                                                              element['DNI'] ==
                                                              provider.user1[k],
                                                          // orElse: () => {},
                                                        )['FULLNAME']
                                                        .toString()),
                                            // readOnly: ,
                                            // suggestionAction: SuggestionAction.next,
                                            hint: 'Usuario 0${k + 1}',
                                            // readOnly: !provider.editable1[k],
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            onSuggestionTap: provider
                                                    .editable1[k]
                                                ? (p0) => provider
                                                    .onChangedUser1(p0.item, k)
                                                : null,
                                            // searchInputDecoration:
                                            //     const InputDecoration(
                                            //   border: OutlineInputBorder(),
                                            //   isDense: true,
                                            //   label: Text('dropdown prueba'),
                                            // ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: DropdownButtonFormField<int>(
                                        //     items: List.generate(
                                        //         provider.users.length, (index) {
                                        //       return DropdownMenuItem(
                                        //         value: provider.users[index]['DNI'],
                                        //         child: Text(provider.users[index]
                                        //                 ['FULLNAME']
                                        //             .toString()),
                                        //       );
                                        //     }),
                                        //     value: provider.user1[k],
                                        //     hint: Text(
                                        //       'Usuario 0${k + 1}',
                                        //       style: const TextStyle(
                                        //         color: Colors.grey,
                                        //       ),
                                        //     ),
                                        //     isExpanded: true,
                                        //     isDense: true,
                                        //     onChanged: provider.editable1[k]
                                        //         ? (value) => provider
                                        //             .onChangedUser1(value, k)
                                        //         : null,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapRemove1(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: provider.editable1[k]
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapEdit1(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              provider.editable1[k]
                                                  ? Icons.save
                                                  : Icons.edit,
                                              color: const Color(0xFF254E5A),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const VerticalDivider(
                            width: 4,
                            thickness: 4,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(provider.user2.length, (k) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SearchField<int>(
                                            suggestionState: Suggestion.expand,
                                            suggestions: List.generate(
                                              provider.users.length,
                                              (index) {
                                                return SearchFieldListItem(
                                                    provider.users[index]
                                                            ['FULLNAME']
                                                        .toString(),
                                                    item: provider.users[index]
                                                        ['DNI'],
                                                    child: Text(provider
                                                        .users[index]
                                                            ['FULLNAME']
                                                        .toString()));
                                              },
                                            ),
                                            enabled: provider.editable2[k],
                                            controller: provider.user2[k] ==
                                                        null ||
                                                    provider.users.isEmpty
                                                ? null
                                                : TextEditingController(
                                                    text: provider.users
                                                        .firstWhere(
                                                          (element) =>
                                                              element['DNI'] ==
                                                              provider.user2[k],
                                                          // orElse: () => {},
                                                        )['FULLNAME']
                                                        .toString()),
                                            hint: 'Usuario 0${k + 1}',
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            onSuggestionTap: provider
                                                    .editable2[k]
                                                ? (p0) => provider
                                                    .onChangedUser2(p0.item, k)
                                                : null,
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: DropdownButtonFormField<int>(
                                        //     items: List.generate(
                                        //         provider.users.length, (index) {
                                        //       return DropdownMenuItem(
                                        //         value: provider.users[index]['DNI'],
                                        //         child: Text(provider.users[index]
                                        //                 ['FULLNAME']
                                        //             .toString()),
                                        //       );
                                        //     }),
                                        //     value: provider.user2[k],
                                        //     hint: Text(
                                        //       'Usuario 0${k + 1}',
                                        //       style: const TextStyle(
                                        //         color: Colors.grey,
                                        //       ),
                                        //     ),
                                        //     isExpanded: true,
                                        //     isDense: true,
                                        //     onChanged: provider.editable2[k]
                                        //         ? (value) => provider
                                        //             .onChangedUser2(value, k)
                                        //         : null,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapRemove2(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: provider.editable2[k]
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapEdit2(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              provider.editable2[k]
                                                  ? Icons.save
                                                  : Icons.edit,
                                              color: const Color(0xFF254E5A),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const VerticalDivider(
                            width: 4,
                            thickness: 4,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(provider.user3.length, (k) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SearchField<int>(
                                            suggestionState: Suggestion.expand,
                                            suggestions: List.generate(
                                              provider.users.length,
                                              (index) {
                                                return SearchFieldListItem(
                                                    provider.users[index]
                                                            ['FULLNAME']
                                                        .toString(),
                                                    item: provider.users[index]
                                                        ['DNI'],
                                                    child: Text(provider
                                                        .users[index]
                                                            ['FULLNAME']
                                                        .toString()));
                                              },
                                            ),
                                            enabled: provider.editable3[k],
                                            controller: provider.user3[k] ==
                                                        null ||
                                                    provider.users.isEmpty
                                                ? null
                                                : TextEditingController(
                                                    text: provider.users
                                                        .firstWhere(
                                                          (element) =>
                                                              element['DNI'] ==
                                                              provider.user3[k],
                                                          // orElse: () => {},
                                                        )['FULLNAME']
                                                        .toString()),
                                            hint: 'Usuario 0${k + 1}',
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            onSuggestionTap: provider
                                                    .editable3[k]
                                                ? (p0) => provider
                                                    .onChangedUser3(p0.item, k)
                                                : null,
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: DropdownButtonFormField<int>(
                                        //     items: List.generate(
                                        //         provider.users.length, (index) {
                                        //       return DropdownMenuItem(
                                        //         value: provider.users[index]['DNI'],
                                        //         child: Text(provider.users[index]
                                        //                 ['FULLNAME']
                                        //             .toString()),
                                        //       );
                                        //     }),
                                        //     value: provider.user3[k],
                                        //     hint: Text(
                                        //       'Usuario 0${k + 1}',
                                        //       style: const TextStyle(
                                        //         color: Colors.grey,
                                        //       ),
                                        //     ),
                                        //     isExpanded: true,
                                        //     isDense: true,
                                        //     onChanged: provider.editable3[k]
                                        //         ? (value) => provider
                                        //             .onChangedUser3(value, k)
                                        //         : null,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapRemove3(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: provider.editable3[k]
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapEdit3(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              provider.editable3[k]
                                                  ? Icons.save
                                                  : Icons.edit,
                                              color: const Color(0xFF254E5A),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const VerticalDivider(
                            width: 4,
                            thickness: 4,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(provider.user4.length, (k) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SearchField<int>(
                                            suggestionState: Suggestion.expand,
                                            suggestions: List.generate(
                                              provider.users.length,
                                              (index) {
                                                return SearchFieldListItem(
                                                    provider.users[index]
                                                            ['FULLNAME']
                                                        .toString(),
                                                    item: provider.users[index]
                                                        ['DNI'],
                                                    child: Text(provider
                                                        .users[index]
                                                            ['FULLNAME']
                                                        .toString()));
                                              },
                                            ),
                                            enabled: provider.editable4[k],
                                            controller: provider.user4[k] ==
                                                        null ||
                                                    provider.users.isEmpty
                                                ? null
                                                : TextEditingController(
                                                    text: provider.users
                                                        .firstWhere(
                                                          (element) =>
                                                              element['DNI'] ==
                                                              provider.user4[k],
                                                          // orElse: () => {},
                                                        )['FULLNAME']
                                                        .toString()),
                                            hint: 'Usuario 0${k + 1}',
                                            suggestionAction:
                                                SuggestionAction.unfocus,
                                            onSuggestionTap: provider
                                                    .editable4[k]
                                                ? (p0) => provider
                                                    .onChangedUser4(p0.item, k)
                                                : null,
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: DropdownButtonFormField<int>(
                                        //     items: List.generate(
                                        //         provider.users.length, (index) {
                                        //       return DropdownMenuItem(
                                        //         value: provider.users[index]['DNI'],
                                        //         child: Text(provider.users[index]
                                        //                 ['FULLNAME']
                                        //             .toString()),
                                        //       );
                                        //     }),
                                        //     value: provider.user4[k],
                                        //     hint: Text(
                                        //       'Usuario 0${k + 1}',
                                        //       style: const TextStyle(
                                        //         color: Colors.grey,
                                        //       ),
                                        //     ),
                                        //     isExpanded: true,
                                        //     isDense: true,
                                        //     onChanged: provider.editable4[k]
                                        //         ? (value) => provider
                                        //             .onChangedUser4(value, k)
                                        //         : null,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapRemove4(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: provider.editable4[k]
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () => provider.onTapEdit4(k),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              provider.editable4[k]
                                                  ? Icons.save
                                                  : Icons.edit,
                                              color: const Color(0xFF254E5A),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
