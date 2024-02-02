import 'dart:math';

import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/providers/users/userview_provider.dart';
import 'package:app_movil_dincydet/src/utils/date_utils.dart';
import 'package:app_movil_dincydet/src/utils/fields.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/qrcodes.dart';
import 'package:app_movil_dincydet/utils/mywidgets/renderqr.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({
    super.key,
    this.isMe = false,
    this.isEdit = false,
  });

  final bool isMe;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewProvider(isMe),
      child: MyScaffold(
        drawer: isMe,
        title: 'Vista de Usuario',
        section: isMe ? DrawerSection.own : DrawerSection.other,
        body: Consumer<UserViewProvider>(builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 180,
                                  child: InkWell(
                                    onTap:
                                        !isEdit ? null : provider.onTapPickIMG,
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: provider.pickedIMG != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: Colors.white,
                                                border: Border.all(
                                                  width: 10.0,
                                                  color: Colors.white,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(blurRadius: 2.0)
                                                ],
                                                image: DecorationImage(
                                                  image: FileImage(
                                                      provider.pickedIMG!),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                          : provider.USERDATA?['PHOTOURL'] ==
                                                  null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    color: Colors.grey,
                                                    border: Border.all(
                                                      width: 10.0,
                                                      color: Colors.white,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(blurRadius: 2.0)
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: const FittedBox(
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImageBuilder(
                                                  url: provider
                                                      .USERDATA?['PHOTOURL'],
                                                  placeHolder:
                                                      const CircularProgressIndicator(),
                                                  errorWidget:
                                                      const Icon(Icons.error),
                                                  builder: ((image) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          width: 10.0,
                                                          color: Colors.white,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              blurRadius: 2.0)
                                                        ],
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(image),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.0,
                                        color: Colors.white,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 2.0)
                                      ],
                                    ),
                                    child: QrImage(
                                      //TODO: Get QR from provider, fix
                                      data: qrStringUser(
                                          Provider.of<MainUserProvider>(context,
                                                      listen: false)
                                                  .USERID ??
                                              0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isMe,
                        child: const SizedBox(width: 10),
                      ),
                      Visibility(
                        visible: isMe,
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: provider.onTapNewTicket,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF6750A4),
                                      ),
                                      child: const Text('Generar Ticket'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: provider.onTapNewDocument,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Text('Generar Papeleta'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: provider.onTapChat,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      child: const Text('Chat'),
                                    ),
                                  ),
                                ],
                              ),
                              // TODO: Complete the buttons here
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Información de Contacto',
                        style: TextStyle(
                          color: Color(0xFF0096C7),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Color(0xFF0096C7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  DropdownButtonFormField<int>(
                    items: List.generate(gradeTypes.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(gradeTypes[index]),
                      );
                    }),
                    onChanged: isEdit ? provider.onChangeGrade : null,
                    value: provider.gradeValue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Grado',
                    ),
                    isExpanded: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.lastnameController,
                    label: 'Apellidos',
                    readOnly: !isEdit,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.nameController,
                    label: 'Nombres',
                    readOnly: !isEdit,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.cipController,
                    label: 'CIP',
                    readOnly: !isEdit,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<int>(
                    items: List.generate(cargosDincydet.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(cargosDincydet[index]),
                      );
                    }),
                    onChanged: isEdit ? provider.onChangePosition : null,
                    value: provider.positionValue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Cargo',
                    ),
                    isExpanded: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<int>(
                    items: List.generate(areasDincydet.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(areasDincydet[index]),
                      );
                    }),
                    onChanged: isEdit ? provider.onChangeLocation : null,
                    value: provider.locationValue,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Area',
                    ),
                    isExpanded: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.addressController,
                    label: 'Dirección',
                    readOnly: !isEdit,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.phoneController,
                    label: 'Teléfono',
                    readOnly: !isEdit,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Tipo de Sangre',
                    ),
                    items: List.generate(bloodTypes.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(bloodTypes[index]),
                      );
                    }),
                    onChanged: provider.onChangeBlood,
                    value: provider.bloodValue,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextField(
                    controller: provider.emailController,
                    label: 'Correo',
                    readOnly: !isEdit,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Condicion',
                        style: TextStyle(
                          color: Color(0xFF0096C7),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Color(0xFF0096C7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Condición Laboral',
                    ),
                    items: List.generate(userLaboralConditions.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(userLaboralConditions[index]),
                      );
                    }),
                    onChanged:
                        !isEdit ? null : provider.onChangeLaboralCondition,
                    value: provider.userLaboralValue,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Condición Temporal',
                    ),
                    items:
                        List.generate(userTemporalConditions.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(userTemporalConditions[index]),
                      );
                    }),
                    onChanged:
                        !isEdit ? null : provider.onChangeTemporalCondition,
                    value: provider.userTemporalValue,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Sesión',
                        style: TextStyle(
                          color: Color(0xFF0096C7),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Color(0xFF0096C7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          label: 'DNI',
                          readOnly: true,
                          controller: provider.dniController,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: provider.onTapEditDNI,
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          label: 'Contraseña',
                          readOnly: true,
                          controller: provider.passController,
                          obscureText: true,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: provider.onTapEditPassword,
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isEdit,
                    child: const SizedBox(
                      height: 15,
                    ),
                  ),
                  Visibility(
                    visible: isEdit,
                    child: Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF101139),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: provider.onTapSave,
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: max(600, widthDevice - 40),
                      child: HistoryUserCard(
                        data: provider.assistanceHistory,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class HistoryUserCard extends StatelessWidget {
  HistoryUserCard({
    super.key,
    required this.data,
  });
  final List<Map<String, dynamic>> data;
  final NumberFormat formatter = NumberFormat('00');
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de ingreso y salida',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7E1008),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              data.length,
                              (index) {
                                return FlSpot(
                                  index.toDouble(),
                                  isoToNumericDate(data[index]['DATE']),
                                );
                              },
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  strokeColor: data[index]['ISIN']
                                      ? const Color(0xFF2B9D0F)
                                      : const Color(0xFF7E1008),
                                  strokeWidth: 3,
                                  color: Colors.white,
                                );
                              },
                            ),
                            color: const Color(0xFF073264),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((e) {
                              String textDate = data[e.x.toInt()]['DATE'];
                              String textType = data[e.x.toInt()]['ISIN']
                                  ? 'Ingreso'
                                  : 'Salida';
                              String totalText =
                                  '${isoToLocalDate(textDate)}\n${isoToLocalTime(textDate)}\n$textType';
                              return LineTooltipItem(
                                totalText,
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        )),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              interval: 2,
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                double integerPart = value.floorToDouble();
                                double decimalPart = value - integerPart;
                                decimalPart = decimalPart * 60;

                                return Text(
                                    '${formatter.format(integerPart)}:${formatter.format(decimalPart)}');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Center(
                                    child:
                                        Text((value + 1).toStringAsFixed(0)));
                              },
                            ),
                          ),
                          topTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                        ),
                        gridData: FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Leyenda:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF615E83),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF2B9D0F),
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Ingreso',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2B9D0F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF7E1008),
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Salida',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF7E1008),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
