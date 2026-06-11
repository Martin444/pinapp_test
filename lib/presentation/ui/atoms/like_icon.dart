import 'package:flutter/material.dart';
import 'package:pinapp_test/core/constants/colors.dart';

/// Átomo: Icono de like
/// 
/// Componente básico que muestra un icono de corazón
/// Puede estar activo o inactivo
class LikeIcon extends StatelessWidget {
  final bool isLiked;
  final double size;
  final VoidCallback? onTap;

  const LikeIcon({
    super.key,
    this.isLiked = false,
    this.size = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? PinAppColors.likeActive : PinAppColors.likeInactive,
        size: size,
      ),
    );
  }
}
