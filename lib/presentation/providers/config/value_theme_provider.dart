
import 'package:flutter_riverpod/legacy.dart';
import 'package:movies_app/presentation/providers/config/index_theme_provider.dart';

final valueThemeProvider = StateProvider<int>(
  (ref) {
    final index = ref.watch(indexThemeProvider);
    return index;
  }
);