import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/constants/colors.dart';
import 'package:pinapp_material_ui/ui/atoms/pin_app_text.dart';

class CommentTile extends StatelessWidget {
  final String name;
  final String email;
  final String body;

  const CommentTile({
    super.key,
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PinAppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PinAppColors.lightGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: PinAppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: PinAppColors.darkBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinAppText(
                      text: name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PinAppColors.navyBlue,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    PinAppText(
                      text: email,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PinAppColors.turquoise,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PinAppText(
            text: body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PinAppColors.textPrimary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
