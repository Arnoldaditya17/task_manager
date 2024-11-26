import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/theme.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.label, required this.onTap});

  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: bluishClr),
        child: Center(child: Text(label,style: const TextStyle(color: Colors.white),)),
      ),
    );
  }
}
