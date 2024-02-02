
import 'package:flutter/material.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({
    super.key,
    this.onTap,
    this.enabled = false,
    this.status,
  });

  final void Function()? onTap;
  final bool enabled;
  final bool? status;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF34C759) : Colors.grey,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                status != true ? Colors.transparent : const Color(0xFF34C759),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class CrossButton extends StatelessWidget {
  const CrossButton({
    super.key,
    this.onTap,
    this.enabled = false,
    this.status,
  });

  final void Function()? onTap;
  final bool enabled;
  final bool? status;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFBA1A1A) : Colors.grey,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                status != false ? Colors.transparent : const Color(0xFFBA1A1A),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class ValidationButton extends StatelessWidget {
  const ValidationButton({
    super.key,
    required this.onTap,
    required this.lastValidation,
    required this.isIn,
    required this.status,
    required this.myUserDNI,
    required this.authUserDNI,
  });
  final void Function(bool value) onTap;
  final bool? lastValidation;
  final bool isIn;
  final bool? status;
  final int? myUserDNI;
  final int? authUserDNI;
  @override
  Widget build(BuildContext context) {
    bool enabled = false;
    if (status == null) {
      if (isIn) {
        enabled = lastValidation ?? false;
      } else {
        enabled = false;
      }
    } else {
      enabled = false;
    }
    if (myUserDNI != authUserDNI) {
      enabled = false;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CheckButton(
          onTap: () => onTap(true),
          enabled: enabled,
          status: status,
        ),
        CrossButton(
          onTap: () => onTap(false),
          enabled: enabled,
          status: status,
        ),
      ],
    );
  }
}
