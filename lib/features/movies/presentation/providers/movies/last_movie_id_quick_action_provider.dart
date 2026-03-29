import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/features.dart';

// ! PROVIDER
final lastMovieIdQuickActionProvider = StateNotifierProvider<LastMovieIdQuickActionNotifier, LastMovieIdQuickActionState>((ref) {
  
  final MovieLastValueStorageServiceImpl movieLastValueStorageServiceImpl = MovieLastValueStorageServiceImpl();
  
  return LastMovieIdQuickActionNotifier(movieLastValueStorageService: movieLastValueStorageServiceImpl);
});
// ! NOTIFIER

class LastMovieIdQuickActionNotifier extends StateNotifier<LastMovieIdQuickActionState> {

  final MovieLastValueStorageService movieLastValueStorageService;

  LastMovieIdQuickActionNotifier({
    required this.movieLastValueStorageService
  }): super(LastMovieIdQuickActionState()){
    getMovieIdValueQuickAction();
  }
  
  Future<String> getMovieIdValueQuickAction() async{
    final String movieId = await movieLastValueStorageService.getValue('movie');

    state = state.copyWith(
      movieId: movieId,
    );

    return movieId;
  }

  void setMovieIdValueQuickAction(String movieId) async{
    await movieLastValueStorageService.setValue('movie', movieId);

    getMovieIdValueQuickAction();

    state = state.copyWith(
      movieId: movieId
    );
  }
}
// ! STATE
class LastMovieIdQuickActionState {
  final String? movieId;

  LastMovieIdQuickActionState({
    this.movieId = ''
  });
  

  LastMovieIdQuickActionState copyWith({
    String? movieId,
  }) => LastMovieIdQuickActionState(
    movieId: movieId ?? this.movieId,
  );
}
