import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';

class InventoryTableHeader extends StatelessWidget {
  const InventoryTableHeader({super.key});

  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF535E78),
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
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              'Nº',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('IBP', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Tipo de bien', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Fecha de registro', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Origen de adquisición', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Ubicación', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Estado', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Condición Final', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Detalle', style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class InventoryTable extends StatelessWidget {
  InventoryTable({
    super.key,
    required this.data,
    required this.onTapDelete,
    required this.onTapEdit,
    required this.onTapDetail,
    this.onRefresh = noRefresh,
  });
  final List<Map> data;
  Future<void> Function() onRefresh;

  static Future<void> noRefresh() async {}
  final TextStyle rowStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  final void Function(int index) onTapDelete;
  final void Function(int index) onTapEdit;
  final void Function(int index) onTapDetail;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const InventoryTableHeader(),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
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
            child: PaginatedWidget(
              itemCount: data.length,
              itemsPerPage: 12,
              onRefresh: onRefresh,
              infoText: "",
              itemBuilder: (context, i) {
                final item = data[i];
                final origin = item['ISPROJECT'] == true
                    ? item['PROJECTNAME']
                    : 'DINCYDET';
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
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB3261E),
                          ),
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
                          item['IBP'],
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          inventoryTypes[item['TYPE']],
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
                          isoToLocalDate(item['CREATEDAT']),
                          style: rowStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(origin, style: rowStyle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          areasDincydet[item['LOCATION']],
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
                          inventoryConditions[item['CONDITION']],
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          item['LASTPROJECTNAME'],
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF254E5A),
                                ),
                                onTap: () => onTapEdit(i),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: const Icon(
                                  Icons.delete_forever,
                                  color: Color(0xFF7E1008),
                                ),
                                onTap: () => onTapDelete(i),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: const Icon(
                                  Icons.info,
                                  color: Color(0xFF254E5A),
                                ),
                                onTap: () => onTapDetail(i),
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
        ),
      ],
    );
  }
}
