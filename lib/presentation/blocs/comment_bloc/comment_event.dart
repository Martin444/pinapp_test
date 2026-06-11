import 'package:equatable/equatable.dart';

/// Eventos del BLoC de comentarios
/// 
/// [CommentFetched] - Evento para cargar comentarios
abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar comentarios de un post
/// 
/// [postId] ID del post para obtener comentarios
class CommentFetched extends CommentEvent {
  final int postId;

  const CommentFetched({required this.postId});

  @override
  List<Object?> get props => [postId];
}
