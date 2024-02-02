import 'package:app_movil_dincydet/pages/budget/budget_fn.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetTableHeader extends StatelessWidget {
  const BudgetTableHeader({super.key});

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
            child: Text('Nº', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Fecha registro solicitud', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Solicitante', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Importe solicitado', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Importe autorizado', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Estado solicitado', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Acciones', style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class BudgetTable extends StatelessWidget {
  BudgetTable({
    super.key,
    required this.data,
    required this.onTapAccept,
    required this.onTapReject,
    required this.onTapDetails,
    this.onRefresh = noRefresh,
  });
  final List<Map> data;
  final void Function(int index) onTapAccept;
  final void Function(int index) onTapReject;
  final void Function(int index) onTapDetails;
  Future<void> Function() onRefresh;
  static Future<void> noRefresh() async {}

  final TextStyle rowStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BudgetTableHeader(),
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
              infoText: "",
              onRefresh: onRefresh,
              itemBuilder: (context, i) {
                final item = data[i];
                final name = item['FROMNAME'];
                final isProject = item['ISPROJECT'];
                final allowAccept = item['ACCEPTBUTTON'];
                final allowReject = item['DENYBUTTON'];
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
                          isoToLocalDate(item['CREATEDAT']),
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(isProject == true ? name : 'DINCYDET',
                            style: rowStyle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('${item['AMOUNT']} PEN', style: rowStyle),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          readOnly: item['STATUS'] != null,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            // Numbers with max two decimals using regex
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          controller: item['AUTHORIZED'],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BudgetStatusWidget(value: item['STATUS']),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap:
                                    allowAccept ? () => onTapAccept(i) : null,
                                child: Icon(
                                  Icons.check,
                                  color: allowAccept
                                      ? const Color(0xFF2B9D0F)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap:
                                    allowReject ? () => onTapReject(i) : null,
                                child: Icon(
                                  Icons.clear,
                                  color: allowReject
                                      ? const Color(0xFFBB271A)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: const Icon(
                                  Icons.info,
                                  color: Color(0xFF073264),
                                ),
                                onTap: () => onTapDetails(i),
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
