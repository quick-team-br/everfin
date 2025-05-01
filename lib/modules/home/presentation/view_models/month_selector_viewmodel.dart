import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthSelectorViewModel extends Notifier<int> {
  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  int build() {
    final currentMonth = DateTime.now().month;
    return currentMonth - 1; // Subtract 1 since list is 0-based
  }

  void selectIndex(int index) {
    if (index >= 0 && index < months.length) {
      state = index;
    }
  }

  String get currentMonth => months[state];
}

final monthSelectorProvider = NotifierProvider<MonthSelectorViewModel, int>(
  () => MonthSelectorViewModel(),
);
