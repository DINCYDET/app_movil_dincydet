import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key, required this.label, required this.controller});
  final String label;
  final TextEditingController controller;
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimePickerProvider>(
      create: ((context) => TimePickerProvider()),
      child: Consumer<TimePickerProvider>(
        builder: (context, provider, child) {
          return TextField(
            controller: widget.controller,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_month),
              isDense: true,
              labelText: widget.label,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onTap: () async {
              final finish = await provider.onTap(context);
              if (finish) {
                provider.updateDate(widget.controller);
              }
            },
          );
        },
      ),
    );
  }
}

class TimePickerProvider extends ChangeNotifier {
  String _date = '';
  String get date => _date;
  Future<bool> onTap(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      _date = formattedDate;
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateDate(TextEditingController controller) {
    controller.text = _date;
    notifyListeners();
  }
}
