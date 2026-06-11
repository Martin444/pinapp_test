import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/constants/colors.dart';

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
