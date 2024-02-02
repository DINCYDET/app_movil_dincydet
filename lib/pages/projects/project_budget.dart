import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectBudgetTable extends StatelessWidget {
  ProjectBudgetTable({
    super.key,
    required this.budgetData,
    required this.onTapDetails,
  });

  final List<Map<String, dynamic>> budgetData;
  final void Function(int index) onTapDetails;

  final TextStyle headerStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  final TextStyle rowStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  // Number format, to show the amount with two decimals and the thousand separator
  final NumberFormat amountFormat = NumberFormat.currency(
    locale: 'en_EN',
    symbol: '',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
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
                child: Text('Fecha registro', style: headerStyle),
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
              SizedBox(
                width: 80,
                child: Text('Estado', style: headerStyle),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 80,
                child: Text('Detalle', style: headerStyle),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: List.generate(budgetData.length, (index) {
              final item = budgetData[index];
              final amount = item['AMOUNT'] as double;
              double? authorizedAmount = item['AUTHMONT'] as double?;
              String authText = 'Pendiente';
              if (authorizedAmount != null) {
                authText = '${amountFormat.format(authorizedAmount)} PEN';
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB3261E),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${index + 1}',
                          style: rowStyle.copyWith(color: Colors.white),
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
                      child: Text('${amountFormat.format(amount)} PEN',
                          style: rowStyle),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(authText,
                          style: rowStyle.copyWith(
                            color: (item['STATUS'] as bool?) != false
                                ? Colors.black
                                : const Color(0xFFBB271A),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: StatusBudgetWidget(
                        status: item['STATUS'] as bool?,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: InkWell(
                        onTap: () => onTapDetails(index),
                        child: const Icon(
                          Icons.info,
                          color: Color(0xFF073264),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class StatusBudgetWidget extends StatelessWidget {
  const StatusBudgetWidget({
    super.key,
    this.status,
  });
  final bool? status;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      color: status == null
          ? const Color(0xFFCA8D32)
          : status!
              ? const Color(0xFF2B9D0F)
              : const Color(0xFFBB271A),
    );
  }
}
