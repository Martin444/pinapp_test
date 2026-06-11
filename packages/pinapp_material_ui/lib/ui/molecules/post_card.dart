import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/constants/colors.dart';
import 'package:pinapp_material_ui/ui/atoms/like_icon.dart';
import 'package:pinapp_material_ui/ui/atoms/pin_app_text.dart';

class PostCard extends StatelessWidget {
  final int id;
  final String title;
  final String body;
  final bool isLiked;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;

  const PostCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    this.isLiked = false,
    this.onTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PinAppText(
                      text: title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PinAppColors.navyBlue,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LikeIcon(
                    isLiked: isLiked,
                    onTap: onLikeTap,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PinAppText(
                text: body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: PinAppColors.textSecondary,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver comentarios',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PinAppColors.turquoise,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: PinAppColors.turquoise,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
