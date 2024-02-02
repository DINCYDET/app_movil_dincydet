import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    this.onTap,
    required this.dateController,
    this.label,
    this.icon,
    this.allowBack = false,
  });

  final void Function()? onTap;
  final TextEditingController dateController;
  final String? label;
  final Icon? icon;
  final bool allowBack;
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimePickerProvider>(
      create: ((context) => TimePickerProvider(allowBack: widget.allowBack)),
      child: SizedBox(
        height: 50,
        child: Consumer<TimePickerProvider>(
          builder: (context, provider, child) {
            return TextField(
              controller: widget.dateController,
              style: const TextStyle(fontSize: 14.0),
              readOnly: true,
              decoration: InputDecoration(
                isDense: true,
                icon: widget.icon,
                contentPadding: const EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 2.0),
                suffixIcon: const Icon(Icons.calendar_month),
                labelText: widget.label ?? 'Seleccione la fecha',
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
                  provider.updateDate(widget.dateController);
                }
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class TimePickerProvider extends ChangeNotifier {
  bool allowBack;
  TimePickerProvider({required this.allowBack});
  String _date = '';
  String get date => _date;
  Future<bool> onTap(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: allowBack ? DateTime(1900) : DateTime.now(),
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

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.inputFormatters,
    required this.controller,
    this.minLines,
    this.maxLines,
    this.prefix,
    this.onTap,
  });
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final Widget? prefix;
  final void Function()? onTap;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        label: Text(label),
        prefixIcon: prefix,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
