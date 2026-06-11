import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/ui/atoms/search_input.dart';

class PostSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const PostSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchInput(
        controller: controller,
        hintText: 'Buscar posts...',
        onChanged: onChanged,
        onClear: onClear,
        focusNode: focusNode,
      ),
    );
  }
}
