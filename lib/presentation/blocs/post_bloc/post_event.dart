import 'package:equatable/equatable.dart';

/// Eventos del BLoC de posts
/// 
/// [PostFetched] - Evento para cargar posts
/// [PostSearched] - Evento para buscar posts
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todos los posts
class PostFetched extends PostEvent {
  const PostFetched();
}

/// Evento para buscar posts
/// 
/// [query] Texto de búsqueda
class PostSearched extends PostEvent {
  final String query;

  const PostSearched(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para actualizar el estado de like de un post
/// 
/// [postId] ID del post
/// [isLiked] Nuevo estado de like
class PostLikeUpdated extends PostEvent {
  final int postId;
  final bool isLiked;

  const PostLikeUpdated({
    required this.postId,
    required this.isLiked,
  });

  @override
  List<Object?> get props => [postId, isLiked];
}
