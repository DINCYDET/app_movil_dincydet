import 'package:flutter/material.dart';

class BudgetStatusWidget extends StatelessWidget {
  const BudgetStatusWidget({
    super.key,
    required this.value,
  });
  final bool? value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Color get color {
    switch (value) {
      case null:
        return const Color(0xFFCA8D32);
      case true:
        return const Color(0xFF2B9D0F);
      case false:
        return const Color(0xFFBB271A);
    }
    return Colors.white;
  }

  String get label {
    switch (value) {
      case null:
        return 'Pendiente';
      case true:
        return 'Autorizado';
      case false:
        return 'Denegado';
    }
    return '-';
  }
}
