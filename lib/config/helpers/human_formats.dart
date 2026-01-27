
import 'package:intl/intl.dart';
class HumanFormats {
  /// Convierte 1500 -> 1.5K, 1000000 -> 1M, etc., usando intl
  static String humanReadableNumber(double number, [int decimals = 1]) {//* decimals es opcional
    final formatter = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol:
          '', // quitamos el símbolo de moneda (por defecto pone $ o algo según el locale)
      locale: 'en'
    );

    return formatter.format(number);
  }

}
   