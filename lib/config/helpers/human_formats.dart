
import 'package:intl/intl.dart';
class HumanFormats {
  /// Convierte 1500 -> 1.5K, 1000000 -> 1M, etc., usando intl
  static String number( double number, [ int decimals = 0 ] ) {

    return NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);
  }

}
   