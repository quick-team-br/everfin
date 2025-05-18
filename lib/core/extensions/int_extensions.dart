import 'package:intl/intl.dart';

extension CentavosExtension on int {
  String toBRL() {
    final reais = this / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(reais);
  }

  String toBRLWithoutSymbol() {
    final reais = this / 100;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: "");
    return formatter.format(reais).trim();
  }
}
