import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/ui/atoms/like_icon.dart';
import 'package:pinapp_material_ui/ui/atoms/pin_app_text.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final int count;
  final VoidCallback? onTap;

  const LikeButton({
    super.key,
    this.isLiked = false,
    this.count = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeIcon(
          isLiked: isLiked,
          onTap: onTap,
        ),
        if (count > 0) ...[
          const SizedBox(width: 4),
          PinAppText(
            text: count.toString(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ],
    );
  }
}
