import 'package:intl/intl.dart';

abstract final class MoneyFormatter {
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern(
    'vi_VN',
  );

  static String vnd(num amount) => '${_numberFormat.format(amount)} ₫';
}
