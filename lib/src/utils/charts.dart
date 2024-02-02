import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart(
      {super.key,
      required this.label,
      required this.data,
      this.num,
      this.child});

  final String label;
  final int? num;
  final List<Map<String, dynamic>> data;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  num != null
                      ? Text(
                          ' $num',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              alignment: Alignment.topCenter,
              child: GisDonutChart(
                data: data,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DrawIndicators(
              data: data,
            ),
            const Spacer(),
            const Divider(),
            child ?? Container(),
          ],
        ),
      ),
    );
  }
}

class GisDonutChart extends StatelessWidget {
  const GisDonutChart({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: DChartPie(
          data: data,
          fillColor: (pieData, index) {
            return data[index!]['color'];
          },
          donutWidth: 40,
          showLabelLine: false,
          labelColor: Colors.transparent,
        ),
      ),
    );
  }
}

class DrawIndicators extends StatelessWidget {
  const DrawIndicators({super.key, required this.data});
  final List<Map> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(data.length, (i) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: data[i]['color'],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    data[i]['domain'],
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: MC_fakeblack,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
              // const Spacer(),
              SizedBox(
                width: 18,
                child: Text(
                  data[i]['measure'].toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Grafico de tickets en el dashboard

class TicketsVertWidget extends StatelessWidget {
  TicketsVertWidget({super.key});

  final List<Color> colors = [
    Colors.blue.shade900,
    Colors.blueAccent,
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "# Tickets",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TicketsVerIndicator(color: colors[0], label: 'Vacaciones'),
                const SizedBox(
                  width: 15,
                ),
                TicketsVerIndicator(color: colors[1], label: 'Permiso'),
                const SizedBox(
                  width: 15,
                ),
                TicketsVerIndicator(color: colors[2], label: 'Hospital'),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: TicketsVertChart(
                      colors: colors,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

class TicketsVerIndicator extends StatelessWidget {
  const TicketsVerIndicator(
      {super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.red),
            color: color,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class TicketsVertChart extends StatelessWidget {
  const TicketsVertChart({super.key, required this.colors});

  final List<Color> colors;
  static const betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
    double cycling,
  ) {
    final pilateColor = colors[0];
    final cyclingColor = colors[1];
    final quickWorkoutColor = colors[2];
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilateColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: cyclingColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff787694),
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JAN';
        break;
      case 1:
        text = 'FEB';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'APR';
        break;
      case 4:
        text = 'MAY';
        break;
      case 5:
        text = 'JUN';
        break;
      case 6:
        text = 'JUL';
        break;
      case 7:
        text = 'AUG';
        break;
      case 8:
        text = 'SEP';
        break;
      case 9:
        text = 'OCT';
        break;
      case 10:
        text = 'NOV';
        break;
      case 11:
        text = 'DEC';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff787694),
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitles,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 20,
              ),
            ),
          ),
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          barGroups: [
            generateGroupData(0, 8, 3, 2),
            generateGroupData(1, 7, 5, 7),
            generateGroupData(2, 10, 3, 8),
            generateGroupData(3, 5, 4, 3),
            generateGroupData(4, 8, 3, 4),
            generateGroupData(5, 2, 6, 8),
            generateGroupData(6, 3, 2, 2),
            generateGroupData(7, 3, 3, 3),
            generateGroupData(8, 2, 8, 5),
            generateGroupData(9, 1, 3, 5),
            generateGroupData(10, 1, 8, 3),
            generateGroupData(11, 2, 4, 8),
          ],
          maxY: 25,
        ),
      ),
    );
  }
}
