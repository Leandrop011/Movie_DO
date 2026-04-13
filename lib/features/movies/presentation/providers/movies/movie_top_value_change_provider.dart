import 'package:flutter_riverpod/legacy.dart';

// ! PROVIDER
final movieTapValueChangeProvider = StateNotifierProvider.autoDispose<MovieTopValueChangeNotifier, MovieTopValueChangeState>((ref) {
  return MovieTopValueChangeNotifier();
});

// ! NOTIFIER

class MovieTopValueChangeNotifier extends StateNotifier<MovieTopValueChangeState> {
  MovieTopValueChangeNotifier(): super(MovieTopValueChangeState());
  
  void changeValue(bool value){
    state = state.copyWith(
      isTaped: value,
    );
  }

}

// ! STATE
class MovieTopValueChangeState {
  final bool isTaped;

  MovieTopValueChangeState({
    this.isTaped = false
  });
  

  MovieTopValueChangeState copyWith({
    bool? isTaped,
  }) => MovieTopValueChangeState(
      isTaped: isTaped ?? this.isTaped,
  );
}
