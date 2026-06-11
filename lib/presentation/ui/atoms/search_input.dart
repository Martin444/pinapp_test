import 'package:flutter/material.dart';
import 'package:pinapp_test/core/constants/colors.dart';

/// Átomo: Campo de búsqueda
/// 
/// Componente básico de input para búsqueda
class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const SearchInput({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? 'Buscar posts...',
        prefixIcon: const Icon(
          Icons.search,
          color: PinAppColors.gray,
        ),
        suffixIcon: controller?.text.isNotEmpty ?? false
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: PinAppColors.gray,
                ),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: PinAppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PinAppColors.turquoise,
            width: 2,
          ),
        ),
      ),
    );
  }
}
