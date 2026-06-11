import 'package:flutter/material.dart';

/// Átomo: Texto con estilos de PinApp
/// 
/// Componente básico de texto que aplica los estilos del tema
class PinAppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const PinAppText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
