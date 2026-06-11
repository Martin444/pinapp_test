import 'package:flutter/material.dart';
import 'package:pinapp_test/presentation/ui/organisms/post_detail.dart';

/// Template: Layout de Detalle
/// 
/// Define la estructura de la página de detalle de un post
/// Incluye AppBar con botón de back y PostDetail
class DetailTemplate extends StatelessWidget {
  final String title;
  final String body;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onBackTap;

  const DetailTemplate({
    super.key,
    required this.title,
    required this.body,
    this.isLiked = false,
    this.onLikeTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackTap ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: PostDetail(
        title: title,
        body: body,
        isLiked: isLiked,
        onLikeTap: onLikeTap,
      ),
    );
  }
}
