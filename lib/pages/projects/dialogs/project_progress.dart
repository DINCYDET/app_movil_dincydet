import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:slider_controller/slider_controller.dart';

class ProjectProgressDialog extends StatefulWidget {
  const ProjectProgressDialog({
    super.key,
    this.isTask = true,
    this.initialValue = 0.0,
  });

  final bool isTask;
  final double initialValue;

  @override
  State<ProjectProgressDialog> createState() => _ProjectProgressDialogState();
}

class _ProjectProgressDialogState extends State<ProjectProgressDialog> {
  late double currentValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Container(
        decoration: const BoxDecoration(
          color: MC_darkblue,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        alignment: Alignment.center,
        child: Text(
          'Progreso de la ${widget.isTask ? 'tarea' : 'subtarea'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        SizedBox(
          child: SliderController(
            value: currentValue,
            onChanged: onChanged,
            min: 0.0,
            max: 100,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Text(
            '${currentValue.toStringAsFixed(0)} %',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: MC_darkblue,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onTapConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: MC_darkblue,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ],
    );
  }

  void onChanged(double value) {
    print('$value-${widget.initialValue}-${value >= widget.initialValue}');
    if (value >= widget.initialValue) {
      currentValue = value.floorToDouble();
      setState(() {});
    } else {
      currentValue = widget.initialValue;
      setState(() {});
    }
  }

  void onTapConfirm() {
    Navigator.of(context).pop(currentValue);
  }
}
