import 'package:intl/intl.dart';

//todo, hace la transformacion de numeros a compactos
//* 1000 => 1k
//* 10000 -> 10k
class HumanFormats {
  
  static String humanReadbleNumber (double number){

    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en'
    ).format(number);


    return formatterNumber;
  }
}