import 'package:intl/intl.dart';

String formatRupiah(double value) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 3)
      .format(value);
}
