import 'package:flutter/material.dart';

class StatsLabelProgressChart extends StatelessWidget {
  const StatsLabelProgressChart({
    super.key,
    required this.name,
    required this.value,
    required this.index,
  });
  final String name;
  final num value;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            width: 5,
            height: 40,
            // Set color from primary colors list with index
            color: Colors.primaries[index % Colors.primaries.length],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF615E83),
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: value / 100,
                        color: color,
                        minHeight: 10,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${value.toStringAsFixed(0)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF535E78),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color get color {
    if (value <= 20) {
      return const Color(0xFFB3261E);
    } else if (value < 70) {
      return const Color(0xFFCA8D32);
    } else {
      return const Color(0xFF2B9D0F);
    }
  }
}
