import 'package:intl/intl.dart';

extension DoubleExtension on double? {
  String toCurrencyFormat() {
    final f = NumberFormat.currency(decimalDigits: 2, symbol: '');
    if (this == null) return '';
    return f.format(this);
  }
}
