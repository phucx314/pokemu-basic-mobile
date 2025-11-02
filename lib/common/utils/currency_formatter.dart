import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Tạo 1 formatter (máy định dạng) dùng dấu phẩy (,) kiểu Mỹ
  static final _coinFormatter = NumberFormat.decimalPattern('en_US');

  /// Biến số 1000000 thành chuỗi "1,000,000"
  static String formatCoin(int amount) {
    return _coinFormatter.format(amount);
  }
}