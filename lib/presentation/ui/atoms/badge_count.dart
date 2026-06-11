import 'package:flutter/material.dart';
import 'package:pinapp_test/core/constants/colors.dart';

/// Átomo: Badge de contador
/// 
/// Muestra un número en un círculo coloreado
class BadgeCount extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final Color? textColor;

  const BadgeCount({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? PinAppColors.pinAppRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: textColor ?? PinAppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
