import 'package:flutter/material.dart';
import 'package:pinapp_test/presentation/ui/atoms/like_icon.dart';
import 'package:pinapp_test/presentation/ui/atoms/pin_app_text.dart';

/// Molécula: Botón de like
/// 
/// Combina el icono de like con texto de contador
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
