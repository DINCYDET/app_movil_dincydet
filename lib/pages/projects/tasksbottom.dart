import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:app_movil_dincydet/src/utils/user_photo.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';

class BottomTaskList extends StatelessWidget {
  const BottomTaskList({
    super.key,
    required this.data,
    this.factor = 0.4,
    this.allowEdit = false,
    this.onTapSetTask,
    this.onTapSetSubTask,
  });
  final Map<String, dynamic> data;
  final double factor;
  final bool allowEdit;
  final void Function(int taskId, int userId, int advance)? onTapSetTask;
  final void Function(int subTaskId, int userId, int advance)? onTapSetSubTask;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> tasks = data['tasks'];
    final int ntasks = tasks.length;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: LayoutBuilder(builder: (context, constrains) {
        final double maxW = constrains.maxWidth * factor;
        return Container(
          width: maxW,
          padding: const EdgeInsets.all(8.0),
          child: ntasks > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    tasks.length,
                    (i) {
                      final Map<String, dynamic> thistask = tasks[i];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: MC_darkblue,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    thistask['NAME'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                  visible: allowEdit,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      onTapSetTask?.call(
                                        thistask['ID'],
                                        thistask['USERDATA']['DNI'],
                                        thistask['ADVANCE'],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 2.0,
                                  color: MC_darkblue,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      children: [
                                        UserPhotoWidget(
                                          photo: thistask['USERDATA']
                                              ['PHOTOURL'],
                                          radius: 25,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(thistask['USERDATA']
                                                  ['FULLNAME']),
                                              Text(
                                                cargosDincydet[thistask[
                                                            'USERDATA']
                                                        ['USERPOSITION'] ??
                                                    0], //TODO: Review this part of code
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Row(
                                                children: [
                                                  const Text('Avance:     '),
                                                  Expanded(
                                                    child: Progresso(
                                                      progressStrokeCap:
                                                          StrokeCap.round,
                                                      backgroundStrokeCap:
                                                          StrokeCap.round,
                                                      progress:
                                                          //TODO: Set the acvance to the correct value
                                                          (thistask['ADVANCE'] *
                                                              1.0 /
                                                              100.0),
                                                      progressColor:
                                                          Colors.orange,
                                                      backgroundColor:
                                                          Colors.grey.shade200,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const VerticalDivider(
                                          thickness: 2.0,
                                          color: MC_darkblue,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Inicio:  '),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 1.0,
                                                    horizontal: 4.0,
                                                  ),
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.grey,
                                                  ),
                                                  child: Text(
                                                      thistask['STARTDATE']),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                const Text('Fin:      '),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 1.0,
                                                    horizontal: 4.0,
                                                  ),
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.grey,
                                                  ),
                                                  child:
                                                      Text(thistask['ENDDATE']),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children:
                                List.generate(thistask['SUBTASKS'].length, (j) {
                              final Map<String, dynamic> thissubtask =
                                  thistask['SUBTASKS'][j];
                              return Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 2.0,
                                          color: MC_darkblue,
                                        ),
                                        Container(
                                          width: 25,
                                          height: 1.0,
                                          color: MC_darkblue,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.grey,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    thissubtask['NAME'],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Visibility(
                                                  visible: allowEdit,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.edit_outlined),
                                                    style: IconButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      onTapSetSubTask?.call(
                                                        thissubtask['ID'],
                                                        thissubtask['USERDATA']
                                                            ['DNI'],
                                                        thissubtask['ADVANCE'],
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 2.0,
                                          color: MC_darkblue,
                                        ),
                                        Container(
                                          width: 25,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Row(
                                              children: [
                                                CachedNetworkImageBuilder(
                                                  url: thissubtask['USERDATA']
                                                          ['PHOTOURL']
                                                      .toString(),
                                                  placeHolder:
                                                      const CircularProgressIndicator(),
                                                  errorWidget: const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                  builder: (image) {
                                                    return Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(image),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(thissubtask[
                                                              'USERDATA']
                                                          ['FULLNAME']),
                                                      Text(
                                                        thissubtask[
                                                                'USERPOSITION']
                                                            .toString(), //TODO: Correct this
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              'Avance:     '),
                                                          Expanded(
                                                            child: Progresso(
                                                              progressStrokeCap:
                                                                  StrokeCap
                                                                      .round,
                                                              backgroundStrokeCap:
                                                                  StrokeCap
                                                                      .round,
                                                              progress: //TODO: add functionality
                                                                  (thissubtask[
                                                                          'ADVANCE'] *
                                                                      0.1 /
                                                                      100.0),
                                                              progressColor:
                                                                  Colors.orange,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  thickness: 2.0,
                                                  color: MC_darkblue,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text('Inicio:  '),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 1.0,
                                                            horizontal: 4.0,
                                                          ),
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: Colors.grey,
                                                          ),
                                                          child: Text(
                                                              thissubtask[
                                                                  'STARTDATE']),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'Fin:      '),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 1.0,
                                                            horizontal: 4.0,
                                                          ),
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: Colors.grey,
                                                          ),
                                                          child: Text(
                                                              thissubtask[
                                                                  'ENDDATE']),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const Text(
                  'No hay tareas registradas',
                  style: TextStyle(
                    color: MC_lightblue,
                    fontSize: 17,
                    fontFamily: 'Poppins',
                  ),
                ),
        );
      }),
    );
  }
}
