import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';

class TextIconLabel extends StatelessWidget {
  const TextIconLabel({super.key, required this.label, required this.number});

  final String label;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          padding: const EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MC_darkblue,
          ),
          child: Text(
            '$number',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: const TextStyle(
            color: MC_darkblue,
            fontSize: 20,
            //fontFamily: 'BalooTammudu',
            //fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}

class TextIconLabel2 extends StatelessWidget {
  const TextIconLabel2(
      {super.key,
      required this.label,
      required this.letter,
      this.main = false});

  final String label;
  final String letter;
  final bool main;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: main ? MC_lightblue : MC_lightblueAccent),
            color: Colors.white,
          ),
          child: Text(
            letter,
            style: TextStyle(
              color: main ? MC_lightblue : MC_lightblueAccent,
              fontSize: 17,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: TextStyle(
            color: main ? MC_lightblue : MC_lightblueAccent,
            fontSize: 17,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
