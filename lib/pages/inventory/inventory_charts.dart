import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InventoryChart extends StatelessWidget {
  const InventoryChart({
    super.key,
    required this.label,
    required this.data,
  });

  final String label;
  final List<Map> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                        sections: List.generate(data.length, (index) {
                      return PieChartSectionData(
                        color: data[index]['color'],
                        value: (data[index]['value'] as int).toDouble(),
                        title: data[index]['value'].toString(),
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    })),
                    swapAnimationCurve: Curves.linear,
                    swapAnimationDuration: const Duration(milliseconds: 150),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: List.generate(data.length, (index) {
                      return LabelIndicator(
                        color: data[index]['color'],
                        label: data[index]['title'],
                        value: data[index]['value'],
                      );
                    }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LabelIndicator extends StatelessWidget {
  const LabelIndicator({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 60,
            color: color,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF615E83),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
