import 'package:flutter/material.dart';
import 'package:pinapp_test/presentation/ui/molecules/search_bar.dart';
import 'package:pinapp_test/presentation/ui/organisms/post_list.dart';

/// Template: Layout de Home
/// 
/// Define la estructura de la página de listado de posts
/// Incluye AppBar, SearchBar y PostList
class HomeTemplate extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final VoidCallback? onPostTap;
  final VoidCallback? onRefresh;

  const HomeTemplate({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onSearchClear,
    this.onPostTap,
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
            child: RefreshIndicator(
              onRefresh: () async {
                onRefresh?.call();
              },
              child: PostList(
                onPostTap: onPostTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
