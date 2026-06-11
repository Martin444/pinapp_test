import 'package:flutter/material.dart';
import 'package:pinapp_test/core/constants/colors.dart';

/// Átomo: Botón con estilos de PinApp
/// 
/// Componente básico de botón que aplica los estilos del tema
class PinAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PinAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? PinAppColors.navyBlue,
          side: const BorderSide(color: PinAppColors.navyBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: PinAppColors.white,
              ),
            )
          : (icon != null ? Icon(icon) : const SizedBox.shrink()),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? PinAppColors.navyBlue,
        foregroundColor: foregroundColor ?? PinAppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
