import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_event.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsUseCase _getCommentsUseCase;

  CommentBloc({
    required GetCommentsUseCase getCommentsUseCase,
  })  : _getCommentsUseCase = getCommentsUseCase,
        super(const CommentInitial()) {
    on<CommentFetched>(_onCommentFetched);
  }

  Future<void> _onCommentFetched(
    CommentFetched event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CommentLoading());
    try {
      final comments = await _getCommentsUseCase.execute(event.postId);
      emit(CommentLoaded(comments: comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
