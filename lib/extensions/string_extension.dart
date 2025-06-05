import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return '';
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String wordCapitalize() {
    if (this.isEmpty) return '';
    return this.toLowerCase().split(' ').map((e) => e.capitalize()).join(' ');
  }

  String typeCapitalize() {
    if (this.isEmpty) return '';
    return this.toLowerCase().split('_').map((e) => e.capitalize()).join(' ');
  }

  String docStatus() {
    return this.isNotEmpty ? 'Submitted' : 'Pending';
  }

  String dateFormat() {
    return DateFormat.yMMMMd().format(DateTime.parse(this));
  }

  String toImage() {
    switch (this.toUpperCase()) {
      case 'DATA_RECHARGE':
        return 'data.png';
      case 'AIRTIME_RECHARGE':
        return 'airtime.png';
      case 'ELECTRICITY_RECHARGE':
        return 'topup.png';
      case 'TRANSFER':
        return 'transfer.png';
      default:
        return 'cash.png';
    }
  }

  String toPhoneFormat() {
    if (this.startsWith('0')) {
      return '+234' + this.replaceFirst('0', '');
    }

    return '+234$this';
  }

  String firstChar() {
    return substring(0, 1).toUpperCase();
  }

  String toInitials() {
    String str = "";

    for (var item in this.split(" ")) {
      if (str.length == 2) break;
      str += item.firstChar();
    }

    return str;
  }
}
