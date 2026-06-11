import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/ui/templates/home_template.dart';

/// Página: Home
/// 
/// Pantalla completa de listado de posts
/// Usa HomeTemplate y conecta con los BLoCs
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const PostFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeTemplate(
      searchController: _searchController,
      onSearchChanged: (query) {
        context.read<PostBloc>().add(PostSearched(query));
      },
      onSearchClear: () {
        context.read<PostBloc>().add(const PostSearched(''));
      },
      onPostTap: () {
        // Navegación se maneja en el PostCard
      },
      onRefresh: () {
        context.read<PostBloc>().add(const PostFetched());
      },
    );
  }
}
