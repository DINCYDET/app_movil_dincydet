import 'package:app_movil_dincydet/pages/documents/documents_utils.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:flutter/material.dart';

class DocumentsTableHeader extends StatelessWidget {
  const DocumentsTableHeader({
    super.key,
  });

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
            child: Text('Solicitante', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Tipo de Papeleta', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Fecha Registro', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Autorizado Tco Cargo', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Autorizado Jefe Dpto', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Autorizado Maestro Armas', style: headerStyle),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text('Autorizado Jefe Personal', style: headerStyle),
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
            child: Text('Motivo', style: headerStyle),
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

class DocumentsTable extends StatelessWidget {
  DocumentsTable({
    super.key,
    required this.data,
    required this.onTapDetail,
    required this.isIn,
    required this.onTapAuth,
    required this.myUserDNI,
    this.onRefresh = noRefresh,
  });
  final List<Map> data;
  Future<void> Function() onRefresh;
  final TextStyle rowStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );
  static Future<void> noRefresh() async {}

  final void Function(int index) onTapDetail;
  final void Function(int index, bool value, int authIndex) onTapAuth;
  final bool isIn;
  final int? myUserDNI;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DocumentsTableHeader(),
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
                          item['USERNAME'],
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
                          documentTypes[item['TYPE']],
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isoToLocalDate(item['CREATEDAT']),
                              style: rowStyle,
                            ),
                            Text(
                              isoToLocalTime(item['CREATEDAT']),
                              style: rowStyle.copyWith(
                                color: const Color(0xFF0096C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ValidationButton(
                          isIn: isIn,
                          status: item['AUTH1'],
                          lastValidation: true,
                          onTap: (value) => onTapAuth(i, value, 1),
                          myUserDNI: myUserDNI,
                          authUserDNI: item['AUTHUSER1'],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ValidationButton(
                          isIn: isIn,
                          status: item['AUTH2'],
                          lastValidation: item['AUTH1'],
                          onTap: (value) => onTapAuth(i, value, 2),
                          myUserDNI: myUserDNI,
                          authUserDNI: item['AUTHUSER2'],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ValidationButton(
                          isIn: isIn,
                          status: item['AUTH3'],
                          lastValidation: item['AUTH2'],
                          onTap: (value) => onTapAuth(i, value, 3),
                          myUserDNI: myUserDNI,
                          authUserDNI: item['AUTHUSER3'],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ValidationButton(
                          isIn: isIn,
                          status: item['AUTH4'],
                          lastValidation: item['AUTH3'],
                          onTap: (value) => onTapAuth(i, value, 4),
                          myUserDNI: myUserDNI,
                          authUserDNI: item['AUTHUSER4'],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          getStatusName(item['STAGE'] ?? 0),
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          getValidatedName(item['STATUS']),
                          style: rowStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          child: const Icon(
                            Icons.info,
                            color: Color(0xFF073264),
                          ),
                          onTap: () => onTapDetail(i),
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

  String getStatusName(int value) {
    switch (value) {
      case 0:
        return 'Pendiente';
      case 1:
        return 'En Proceso';
      case 2:
        return 'Archivado';
      default:
        return 'Pendiente';
    }
  }

  String getValidatedName(bool? value) {
    if (value == null) {
      return 'Pendiente';
    }
    return value ? 'Aprobado' : 'Rechazado';
  }
}
