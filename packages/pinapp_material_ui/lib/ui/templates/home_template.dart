import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/models/post_item_data.dart';
import 'package:pinapp_material_ui/ui/molecules/search_bar.dart';
import 'package:pinapp_material_ui/ui/organisms/post_list.dart';

class HomeTemplate extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final List<PostItemData> posts;
  final bool isLoading;
  final String? errorMessage;
  final void Function(int postId) onLikeToggle;
  final void Function(int postId, String title, String body) onPostTap;
  final VoidCallback onRetry;
  final VoidCallback? onRefresh;

  const HomeTemplate({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onSearchClear,
    required this.posts,
    this.isLoading = false,
    this.errorMessage,
    required this.onLikeToggle,
    required this.onPostTap,
    required this.onRetry,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PinApp Posts'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PostSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
            onClear: onSearchClear,
          ),
          Expanded(
            child: PostList(
              posts: posts,
              isLoading: isLoading,
              errorMessage: errorMessage,
              onLikeToggle: onLikeToggle,
              onPostTap: onPostTap,
              onRetry: onRetry,
              onRefresh: onRefresh,
            ),
          ),
        ],
      ),
    );
  }
}
