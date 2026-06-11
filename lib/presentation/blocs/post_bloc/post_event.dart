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

/// Evento para toggle like de un post
class PostLikeUpdated extends PostEvent {
  final int postId;

  const PostLikeUpdated({required this.postId});

  @override
  List<Object?> get props => [postId];
}
