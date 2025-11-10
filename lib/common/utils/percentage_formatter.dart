import 'package:intl/intl.dart';

class PercentageFormatter {
  static final _percentageFormatter = NumberFormat('##0.00%', 'en_US');

  /// Biến số 0.005 thành 0.5%
  static String formatPercentage(double number) {
    return _percentageFormatter.format(number);
  }
}