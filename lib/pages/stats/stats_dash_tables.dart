import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';

class StatsDashboardToValidateTable extends StatelessWidget {
  StatsDashboardToValidateTable({
    super.key,
    required this.data,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.onTapDetails,
    this.onRefresh = noRefresh,
  });

  final List<Map<String, dynamic>> data;
  final void Function(int index) onTapEdit;
  final void Function(int index) onTapDelete;
  final void Function(int index) onTapDetails;
  Future<void> Function() onRefresh;

  static Future<void> noRefresh() async {}

  final TextStyle rowstyle = const TextStyle(
    fontSize: 14,
    color: Color(0xFF535E78),
  );
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF535E78),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  'Nº',
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Nombre',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Nº Subtareas',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Detalle',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: PaginatedWidget(
            itemsPerPage: 6,
            infoText: '',
            itemCount: data.length,
            onRefresh: onRefresh,
            itemBuilder: (context, i) {
              final item = data[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20.0,
                ),
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
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        item['NAME'],
                        style: rowstyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        (item['SUBTASKS'] as List).length.toString(),
                        style: rowstyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => onTapEdit(i),
                            child: const Icon(Icons.edit,
                                color: Color(0xFF254E5A)),
                          ),
                          InkWell(
                            onTap: () => onTapDelete(i),
                            child: const Icon(
                              Icons.delete,
                              color: Color(0xFF7E1008),
                            ),
                          ),
                          InkWell(
                            onTap: () => onTapDetails(i),
                            child: const Icon(
                              Icons.info,
                              color: Color(0xFF073264),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: item['VALIDATED'] == null,
                      child: const Spacer(),
                    ),
                    Visibility(
                      visible: item['VALIDATED'] != null,
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFCA8D32),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Validación solicitada',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StatsDashboardValidatedTable extends StatelessWidget {
  StatsDashboardValidatedTable({
    super.key,
    required this.data,
    required this.onTapDetails,
    required this.onTapDelete,
    this.onRefresh = noRefresh,
  });

  final List<Map<String, dynamic>> data;
  final void Function(int index) onTapDetails;
  final void Function(int index) onTapDelete;
  Future<void> Function() onRefresh;

  static Future<void> noRefresh() async {}

  final TextStyle rowstyle = const TextStyle(
    fontSize: 14,
    color: Color(0xFF535E78),
  );
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF535E78),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  'Nº',
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Nombre',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  '% Avance',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Detalle',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: PaginatedWidget(
            itemsPerPage: 6,
            infoText: '',
            onRefresh: onRefresh,
            itemCount: data.length,
            itemBuilder: (context, i) {
              final item = data[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20.0,
                ),
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
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        item['NAME'],
                        style: rowstyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              value: item['ADVANCE'] / 100.0,
                              backgroundColor: const Color(0xFFD9D9D9),
                              color: getAdvanceColor(item['ADVANCE']),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${item['ADVANCE']}%'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => onTapDelete(i),
                            child: const Icon(
                              Icons.delete,
                              color: Color(0xFF7E1008),
                            ),
                          ),
                          InkWell(
                            onTap: () => onTapDetails(i),
                            child: const Icon(
                              Icons.info,
                              color: Color(0xFF073264),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: item['COMPLETIONVALIDATED'] == null,
                      child: const Spacer(),
                    ),
                    Visibility(
                      visible: item['COMPLETIONVALIDATED'] == false,
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFCA8D32),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Validación solicitada',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color getAdvanceColor(int value) {
    if (value < 40) {
      return const Color(0xFFB3261E);
    } else if (value < 100) {
      return const Color(0xFFCA8D32);
    } else {
      return const Color(0xFF2B9D0F);
    }
  }
}

class StatsDashboardCompletedTable extends StatelessWidget {
  StatsDashboardCompletedTable({
    super.key,
    required this.data,
    required this.onTapDetails,
    this.onRefresh = noRefresh,
  });

  final List<Map<String, dynamic>> data;
  final void Function(int i) onTapDetails;
  Future<void> Function() onRefresh;

  static Future<void> noRefresh() async {}

  final TextStyle rowstyle = const TextStyle(
    fontSize: 14,
    color: Color(0xFF535E78),
  );
  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF535E78),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  'Nº',
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Nombre',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  'Fecha de Culminación',
                  style: headerStyle,
                ),
              ),
              const SizedBox(
                width: 20,
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
          height: 10,
        ),
        Expanded(
          child: PaginatedWidget(
            itemsPerPage: 6,
            infoText: '',
            onRefresh: onRefresh,
            itemCount: data.length,
            itemBuilder: (context, i) {
              final item = data[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20.0,
                ),
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
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        item['NAME'],
                        style: rowstyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        isoToLocalDate(item['COMPLETIONDATE']),
                        style: rowstyle,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => onTapDetails(i),
                            child: const Icon(
                              Icons.info,
                              color: Color(0xFF073264),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
