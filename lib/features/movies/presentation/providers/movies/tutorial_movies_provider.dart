import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/features/features.dart';

// ! PROVIDER
final tutorialMoviesProvider = StateNotifierProvider.autoDispose<TutorialMoviesNotifier, TutorialMoviesState>((ref) {
  
  final TutorialValueStorageServiceImpl tutorialValueStorageServiceImpl = TutorialValueStorageServiceImpl(); 

  return TutorialMoviesNotifier( tutorialValueStorageService: tutorialValueStorageServiceImpl );
});

// ! NOTIFIER
class TutorialMoviesNotifier extends StateNotifier<TutorialMoviesState> {

  final TutorialValueStorageService tutorialValueStorageService;

  TutorialMoviesNotifier({
    required this.tutorialValueStorageService
  }): super(TutorialMoviesState()){
    // ? PARA QUE APENAS EJECUTE EL PROVIDER LA APP OBTENGA EL VALUE EN CACHE Y ACTUALICE EL ESTADO
    getValueTutorial();
  }
  
  void getValueTutorial() async{
    final value = await tutorialValueStorageService.getValueTutotrial('tutorial_value');

    state = state.copyWith(
      didExecuted: value,
    );
  }

  void setValueTutorial(bool value) async{
    await tutorialValueStorageService.setValueTutorial(value, 'tutorial_value');

    state = state.copyWith(
      didExecuted: value,
    );
  }

}

// ! STATE
class TutorialMoviesState {
  final bool didExecuted;

  TutorialMoviesState({
    this.didExecuted = false
  });

  TutorialMoviesState copyWith({
    bool? didExecuted,
  }) => TutorialMoviesState(
      didExecuted: didExecuted ?? this.didExecuted,
  );
  
}
