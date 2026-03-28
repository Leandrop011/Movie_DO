// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/legacy.dart';

// ! PROVIDER
final videoStartProvider = StateNotifierProvider.autoDispose<VideoStartNotifier, VideoStartState>((ref) {
  return VideoStartNotifier();
});
// ! NOTIFIER
class VideoStartNotifier extends StateNotifier<VideoStartState> {
  VideoStartNotifier(): super(VideoStartState());

  void changeStart({bool? value}){
    state = state.copyWith(
      start: value ?? !state.start,
    );
  }
  
}
// ! STATE
class VideoStartState {
  final bool start;

  VideoStartState({
    this.start = false
  });
  

  VideoStartState copyWith({
    bool? start,
  }) => VideoStartState(
      start: start ?? this.start,
  );
  
}
