import 'package:app_movil_dincydet/utils/mywidgets/paginatedwidget.dart';
import 'package:app_movil_dincydet/providers/users/users_provider.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progresso/progresso.dart';
import 'package:provider/provider.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final maxW = constrains.maxWidth;
        final spaces = [5, 24, 12, 10, 12, 10, 15];
        return Consumer<UsersProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                UsersTableHeader(
                  spaces: spaces,
                  dx: 1,
                  maxW: maxW,
                ),
                Expanded(
                  child: PaginatedWidget(
                    infoText: '${provider.users.length} Usuarios',
                    enableSearch: true,
                    onChangedSearch: provider.onChangedSearch,
                    itemCount: provider.filteredItems.length,
                    itemsPerPage: 8,
                    onRefresh: provider.updateUsers,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        )),
                        child: UsersTableRow(
                          data: provider.filteredItems[i],
                          spaces: spaces,
                          dx: 1,
                          maxW: maxW,
                          index: i,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class UsersTableHeader extends StatelessWidget {
  const UsersTableHeader(
      {super.key, required this.spaces, required this.dx, required this.maxW});
  final List<int> spaces;
  final int dx;
  final double maxW;
  final TextStyle headerstyle = const TextStyle(
      fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(dx * 0.5 * maxW / 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[0] * maxW / 100,
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[1] * maxW / 100,
              child: Text(
                'Nombres y Apellidos',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[2] * maxW / 100,
              child: Text(
                'Cargo',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[3] * maxW / 100,
              child: Text(
                'Area',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[4] * maxW / 100,
              child: Text(
                '% Avanzado',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[5] * maxW / 100,
              child: Text(
                'Estado',
                style: headerstyle,
              ),
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
            SizedBox(
              width: spaces[6] * maxW / 100,
            ),
            SizedBox(
              width: dx * maxW / 100,
            ),
          ],
        ),
      ),
    );
  }
}

class UsersTableRow extends StatelessWidget {
  const UsersTableRow({
    super.key,
    required this.data,
    required this.spaces,
    required this.dx,
    required this.maxW,
    required this.index,
  });
  final TextStyle rowstyle = const TextStyle(fontSize: 16, color: Colors.blue);
  final Map<String, dynamic> data;
  final List<int> spaces;
  final int dx;
  final double maxW;
  final int index;

  static NumberFormat dniFormat = NumberFormat('00000000');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: dx * 0.5 * maxW / 100, vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[0] * maxW / 100,
            child: data['PHOTOURL'] == null
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : CachedNetworkImageBuilder(
                    //url: '${apiBase}uploads/users/${data['photo']}',
                    url: data['PHOTOURL'],
                    builder: ((image) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: FileImage(image), fit: BoxFit.contain)),
                      );
                    }),
                    placeHolder: const CircularProgressIndicator(),
                    errorWidget: const Icon(Icons.error),
                    imageExtensions: const ['jpg', 'jpeg', 'png'],
                  ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[1] * maxW / 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['FULLNAME'],
                  style: rowstyle,
                ),
                Text(
                  'DNI: ${dniFormat.format(data['DNI'])}',
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[2] * maxW / 100,
            child: Text(
              data['POSITIONNAME'] ?? '',
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[3] * maxW / 100,
            child: Text(
              data['AREANAME'] ?? '',
              style: rowstyle,
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[4] * maxW / 100,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Progresso(
                      progress: data['PROGRESS'] / 100.0,
                      progressStrokeCap: StrokeCap.round,
                      backgroundStrokeCap: StrokeCap.round,
                      progressStrokeWidth: 15.0,
                      backgroundStrokeWidth: 15.0,
                      backgroundColor: Colors.grey.shade300,
                      progressColor: data['PROGRESS'] < 20
                          ? Colors.red
                          : data['PROGRESS'] < 75
                              ? Colors.amber
                              : Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                data['PROGRESS'] < 20
                    ? const Icon(
                        Icons.info,
                        color: Colors.red,
                      )
                    : data['PROGRESS'] < 75
                        ? const Icon(
                            Icons.info,
                            color: Colors.amber,
                          )
                        : const Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[5] * maxW / 100,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: data['STATUS'] == true ? Colors.green : Colors.red,
                      shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 5,
                ),
                data['STATUS'] == true
                    ? Text(
                        'Presente',
                        style: rowstyle,
                      )
                    : Text(
                        'Falto',
                        style: rowstyle,
                      )
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
          SizedBox(
            width: spaces[6] * maxW / 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<UsersProvider>(context, listen: false)
                        .onTapEditUser(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.all(3.0),
                    child: const Icon(Icons.edit),
                  ),
                ),
                Consumer<UsersProvider>(
                  builder: (context, provider, child) {
                    return InkWell(
                      onTap: () => provider.onTapDelete(index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.all(3.0),
                        child: const Icon(Icons.delete_outline_outlined),
                      ),
                    );
                  },
                ),
                Consumer<UsersProvider>(
                  builder: (context, provider, child) {
                    return InkWell(
                      onTap: () => provider.onTapViewUser(index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.all(3.0),
                        child: const Icon(Icons.more_horiz),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: dx * maxW / 100,
          ),
        ],
      ),
    );
  }
}
